class CreateDonationPages < ActiveRecord::Migration
  def self.up
    create_table :donation_pages do |t|

      t.integer :user_id

      t.integer :product_id

      t.text :summary

      t.float :admin_contribution

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
    drop_table :donation_pages
  end
end