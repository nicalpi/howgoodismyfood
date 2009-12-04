class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.decimal :portion
      t.integer :energy
      t.decimal :protein
      t.decimal :carbohydrates
      t.decimal :fat
      t.decimal :saturates
      t.decimal :fibre
      t.decimal :sodium
      t.decimal :added_sugars
      t.string :barcode

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
