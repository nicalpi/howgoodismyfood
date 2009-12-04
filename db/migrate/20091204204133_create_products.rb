class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string  :name
      t.integer :energy
      
      t.decimal :portion,       :precision => 6, :scale => 2
      t.decimal :protein,       :precision => 5, :scale => 2
      t.decimal :carbohydrate,  :precision => 5, :scale => 2
      t.decimal :sugar,         :precision => 5, :scale => 2
      t.decimal :fat,           :precision => 5, :scale => 2
      t.decimal :saturate,      :precision => 5, :scale => 2
      t.decimal :fibre,         :precision => 5, :scale => 2
      t.decimal :sodium,        :precision => 5, :scale => 2
      t.decimal :added_sugar,   :precision => 5, :scale => 2
      
      t.string  :barcode
      t.string  :kind
            
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
