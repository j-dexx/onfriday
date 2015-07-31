class Create<%= plural_class_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= plural_name %> do |t|
      t.string :name
      t.text :summary
      t.text :main_content
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
    drop_table :<%= plural_name %>
  end
end
