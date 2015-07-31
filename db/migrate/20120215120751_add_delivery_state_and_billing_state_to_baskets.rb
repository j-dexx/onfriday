class AddDeliveryStateAndBillingStateToBaskets < ActiveRecord::Migration
  def self.up
    add_column :baskets, :billing_state, :string
    add_column :baskets, :delivery_state, :string
  end

  def self.down
    remove_column :baskets, :delivery_state
    remove_column :baskets, :billing_state
  end
end
