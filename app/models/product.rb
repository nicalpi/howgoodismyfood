class Product < ActiveRecord::Base
  
  validates_presence_of   :name
  validates_uniqueness_of :barcode
  validates_format_of     :barcode, :with => /\A[0-9A-Z]+\Z/
  
  validates_inclusion_of :kind, :in => %w( food drink )
  
  validates_inclusion_of :portion, :in => 0..1000
  
  validates_inclusion_of :sugar,        :in => 0..100
  validates_inclusion_of :fat,          :in => 0..100
  validates_inclusion_of :saturate,     :in => 0..100
  validates_inclusion_of :sodium,       :in => 0..100
  validates_inclusion_of :fibre,        :in => 0..100,   :allow_nil => true
  validates_inclusion_of :protein,      :in => 0..100,   :allow_nil => true
  validates_inclusion_of :carbohydrate, :in => 0..100,   :allow_nil => true
  validates_inclusion_of :energy,       :in => 0..10000, :allow_nil => true
  validates_inclusion_of :carbohydrate, :in => 0..100,   :allow_nil => true
  validates_inclusion_of :added_sugar,  :in => 0..100,   :if => :added_sugars_needed?
  
  validate :added_sugar_amount_correct?
  
  def barcode=(code)
    write_attribute(:barcode, code.upcase.gsub(/[ \-]/,"") )
  end
  
  def fsa
    {
      :fat      => fsa_fat,
      :sugar    => fsa_sugar,
      :saturate => fsa_saturate,
      :sodium   => fsa_sodium
    }
  end
  
  def per_portion
    @per_portion ||= ingredients.inject({}) do |hash,ingredient|
      hash = {
        ingredient => (portion / 100) * self[ingredient]
      }.merge(hash) if self[ingredient]
      hash
    end
  end
  
  def ingredients
    [:sugar, :fat, :saturate, :sodium, :fibre, :protein, :carbohydrate, :added_sugar]
  end

private
  
  def fsa_fat
    if per_portion[:fat] > 21
      :red
    else
      case fat
        when 0..3  : :green
        when 3..20 : :amber
        else :red
      end
    end
  end
  
  def fsa_saturate
    if per_portion[:saturate] > 6
      :red
    else
      case saturate
        when 0..1.5 : :green
        when 1.5..5 : :amber
        else :red
      end
    end
  end
  
  def fsa_sugar
    if sugar <= 5
      :green
    elsif  ((portion > 100 && per_portion[:added_sugar] <= 15) || portion <= 100) && added_sugar <= 12.5
      :amber
    else
      :red
    end
  end
  
  def fsa_sodium
    if per_portion[:sodium] > 2.4
      :red
    else
      case sodium
        when 0..0.3 : :green
        when 0.3..1.5 : :amber
        else :red
      end
    end
  end
  
  def added_sugar_amount_correct?
    errors.add :added_sugar, 'must be less than total sugars' if added_sugar? && (added_sugar > sugar)
  end
  
  def added_sugars_needed?
    sugar? && sugar > 5
  end
  
end
