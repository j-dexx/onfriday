class AddNewInAndSaleToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :new_in, :boolean, :default => false
  end

  def self.down
    remove_column :products, :new_in
  end
end
