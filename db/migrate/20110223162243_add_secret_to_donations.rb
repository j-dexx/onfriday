class AddSecretToDonations < ActiveRecord::Migration
  def self.up
    add_column :donations, :secret, :boolean
  end

  def self.down
    remove_column :donations, :secret
  end
end
