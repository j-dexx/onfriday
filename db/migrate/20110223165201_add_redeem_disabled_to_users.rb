class AddRedeemDisabledToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :redeem_disabled, :boolean
  end

  def self.down
    remove_column :users, :redeem_disabled
  end
end
