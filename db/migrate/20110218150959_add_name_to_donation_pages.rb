class AddNameToDonationPages < ActiveRecord::Migration
  def self.up
    add_column :donation_pages, :name, :string
  end

  def self.down
    remove_column :donation_pages, :name
  end
end
