class AddGiftCertificateFieldsToBasketItemsAndBookingItems < ActiveRecord::Migration
  def self.up
    add_column :basket_items, :basket_item_type, :integer, :default => 0
    add_column :basket_items, :name, :string
    add_column :basket_items, :email, :string
    add_column :basket_items, :message, :text
    add_column :basket_items, :value, :float, :default => 0
    add_column :basket_items, :delivery_type, :string
    
    add_column :order_items, :order_item_type, :integer, :default => 0
    add_column :order_items, :name, :string
    add_column :order_items, :email, :string
    add_column :order_items, :message, :text
    add_column :order_items, :value, :float, :default => 0
    add_column :order_items, :delivery_type, :string
  end

  def self.down
    remove_column :basket_items, :basket_item_type
    remove_column :basket_items, :name
    remove_column :basket_items, :email
    remove_column :basket_items, :message
    remove_column :basket_items, :value
    remove_column :basket_items, :delivery_type
    
    remove_column :order_items, :order_item_type
    remove_column :order_items, :name
    remove_column :order_items, :email
    remove_column :order_items, :message
    remove_column :order_items, :value
    remove_column :order_items, :delivery_type
  end
end
