class Create<%= class_name %>Images < ActiveRecord::Migration
  def self.up
    create_table :<%= singular_name %>_images do |t|
      t.integer :<%= singular_name %>_id
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.string :image_alt

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
    drop_table :<%= singular_name %>_images
  end
end
