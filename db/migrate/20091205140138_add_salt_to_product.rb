class AddSaltToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :salt, :decimal, :precision => 5, :scale => 2
  end

  def self.down
    remove_column :products, :salt
  end
end
