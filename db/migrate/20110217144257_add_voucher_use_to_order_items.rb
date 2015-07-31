class AddVoucherUseToOrderItems < ActiveRecord::Migration
  def self.up
    add_column :order_items, :used_user, :integer
  end

  def self.down
    remove_column :order_items, :used_user
  end
end
