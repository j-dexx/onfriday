class AddCodeToOrderItems < ActiveRecord::Migration
  def self.up
    add_column :order_items, :code, :string
  end

  def self.down
    remove_column :order_items, :code
  end
end
