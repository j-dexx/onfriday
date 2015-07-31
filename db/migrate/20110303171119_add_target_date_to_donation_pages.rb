class AddTargetDateToDonationPages < ActiveRecord::Migration
  def self.up
    add_column :donation_pages, :target_date, :date
  end

  def self.down
    remove_column :donation_pages, :target_date
  end
end
