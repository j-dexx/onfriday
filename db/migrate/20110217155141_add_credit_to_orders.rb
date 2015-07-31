class AddCreditToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :credit, :float
  end

  def self.down
    remove_column :orders, :credit
  end
end
