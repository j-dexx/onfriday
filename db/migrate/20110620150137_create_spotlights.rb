class CreateSpotlights < ActiveRecord::Migration
  def self.up
    create_table :spotlights do |t|

      t.string :designer

      t.string :company

      t.text :summary

      t.text :content

      t.integer :brand_id

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
    drop_table :spotlights
  end
end