class AddTargetIdToBasketItemsAndBookingItems < ActiveRecord::Migration
  def self.up
    add_column :basket_items, :target_id, :integer
    add_column :order_items, :target_id, :integer
  end

  def self.down
    remove_column :basket_items, :target_id
    remove_column :order_items, :target_id
  end
end
