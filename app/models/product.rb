class Product < ActiveRecord::Base
  
  validates_presence_of   :name
  validates_uniqueness_of :barcode
  validates_format_of     :barcode, :with => /\A[0-9A-Z]+\Z/
  
  validates_inclusion_of :kind, :in => %w( food drink )
  
  validates_inclusion_of :energy,  :in => 0..10000
  validates_inclusion_of :portion, :in => 0..1000
  
  validates_inclusion_of :protein,      :in => 0..100
  validates_inclusion_of :carbohydrate, :in => 0..100
  validates_inclusion_of :sugar,        :in => 0..100
  validates_inclusion_of :fat,          :in => 0..100
  validates_inclusion_of :saturate,     :in => 0..100
  validates_inclusion_of :fibre,        :in => 0..100
  validates_inclusion_of :sodium,       :in => 0..100
  validates_inclusion_of :added_sugar,  :in => 0..100, :if => :added_sugars_needed?

  validate :added_sugar_amount_correct?
  
  def barcode=(code)
    write_attribute(:barcode, code.upcase.gsub(/[ \-]/,"") )
  end

private
  
  def added_sugar_amount_correct?
    errors.add :added_sugar, 'must be less than total sugars' if added_sugar && (added_sugar > sugar) 
  end
  
  def added_sugars_needed?
    sugar && sugar > 5
  end
  
end
