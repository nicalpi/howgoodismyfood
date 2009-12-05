class Product < ActiveRecord::Base
  
  validates_presence_of   :name
  validates_uniqueness_of :barcode
  validates_format_of     :barcode, :with => /\A[0-9A-Z]+\Z/
  
  validates_inclusion_of :kind, :in => %w( food drink )
  
  validates_inclusion_of :portion, :in => 0..1000
  
  validates_inclusion_of :sugar,        :in => 0..100
  validates_inclusion_of :fat,          :in => 0..100
  validates_inclusion_of :saturate,     :in => 0..100
  validates_inclusion_of :sodium,       :in => 0..100,   :if => Proc.new { |p| !p.salt? || p.sodium?  }
  validates_inclusion_of :salt,         :in => 0..100,   :if => Proc.new { |p| p.salt?  || !p.sodium? }  
  validates_inclusion_of :fibre,        :in => 0..100,   :allow_nil => true
  validates_inclusion_of :protein,      :in => 0..100,   :allow_nil => true
  validates_inclusion_of :carbohydrate, :in => 0..100,   :allow_nil => true
  validates_inclusion_of :energy,       :in => 0..10000, :allow_nil => true
  validates_inclusion_of :carbohydrate, :in => 0..100,   :allow_nil => true
  validates_inclusion_of :added_sugar,  :in => 0..100,   :if => :added_sugars_needed?
  
  validate :added_sugar_amount_correct?
  
  def kind
    read_attribute(:kind) || "food"
  end
  
  def barcode=(code)
    write_attribute(:barcode, code.upcase.gsub(/[ \-]/,"") )
  end
  
  def fsa
    {
      :fat      => fsa_calculation( :fat ),
      :sugar    => fsa_sugar,
      :saturate => fsa_calculation( :saturate ),
      :salt     => fsa_calculation( :sodium_expressed_as_salt )
    }
  end
  
  def per_portion
    @per_portion ||= ingredients.inject({}) do |hash,ingredient|
      hash.merge!(
        ingredient => (portion / 100) * self.send( ingredient )
      ) if self.send( ingredient )
      hash
    end
  end
  
  def ingredients
    [:sugar, :fat, :saturate, :sodium, :salt, :fibre, :protein, :carbohydrate, :added_sugar, :sodium_expressed_as_salt]
  end

  def self.fsa_boundries
    {
      "drink" => {
        :fat      => {:medium_per_100 => 1.50..10.00 },
        :saturate => {:medium_per_100 => 0.75..2.50  },
        :sugar    => {:medium_per_100 => 2.50..6.30  },
        :sodium_expressed_as_salt => {:medium_per_100 => 0.30..1.50  },
      },    
      "food"  => {
        :fat      => {:medium_per_100 => 3.00..20.00, :high_per_portion => 21.00 },
        :saturate => {:medium_per_100 => 1.50..5.00,  :high_per_portion =>  6.00 },
        :sugar    => {:medium_per_100 => 5.00..12.50, :high_per_portion => 15.00 },
        :sodium_expressed_as_salt => {:medium_per_100 => 0.30..1.50,  :high_per_portion =>  2.40 },
      }
    }
  end

  def fsa_boundries
    self.class.fsa_boundries[ self.kind ]
  end
  
private

  def sodium_expressed_as_salt
    sodium? ? sodium * 2.5 : salt || 0
  end
    
  def fsa_sugar
    stat = fsa_boundries[:sugar]
    if stat.has_key?(:high_per_portion) && per_portion[:sugar] > stat[:high_per_portion]
      :high
    else
      case self[:sugar]
      when 0..stat[:medium_per_100].begin
        :low
      else
        added_sugar <= stat[:medium_per_100].end ? :medium : :high
      end
    end
  end
  
  def fsa_calculation(attribute)
    stat = fsa_boundries[attribute]
    if stat.has_key?(:high_per_portion) && per_portion[attribute] > stat[:high_per_portion]
      :high
    else
      case self.send(attribute)
        when 0..stat[:medium_per_100].begin : :low
        when stat[:medium_per_100]          : :medium
        else :high
      end
    end
  end
  
  def added_sugar_amount_correct?
    errors.add :added_sugar, 'must be less than total sugars' if added_sugar? && (added_sugar > sugar)
  end
  
  def added_sugars_needed?
    sugar? && fsa_boundries && sugar > fsa_boundries[:sugar][:medium_per_100].begin
  end
  
end
