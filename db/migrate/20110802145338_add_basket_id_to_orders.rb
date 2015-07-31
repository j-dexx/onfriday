class AddBasketIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :basket_id, :integer
  end

  def self.down
    remove_column :orders, :basket_id
  end
end
