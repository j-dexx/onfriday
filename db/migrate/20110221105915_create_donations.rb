class CreateDonations < ActiveRecord::Migration
  def self.up
    create_table :donations do |t|

      t.integer :order_item_id

      t.integer :donation_page_id

      t.text :message

      t.float :value

      t.integer :user_id

      t.timestamps
      t.integer :created_by
      t.integer :updated_by
      t.boolean :recycled, :default => false
      t.datetime :recycled_at
      t.boolean :display, :default => true
      t.integer :position, :default => 0
    end
  end
  
  def self.down
    drop_table :donations
  end
end
