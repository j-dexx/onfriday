class AddAttachmentsImageToSpotlight < ActiveRecord::Migration
  def self.up
    add_column :spotlights, :image_file_name, :string
    add_column :spotlights, :image_content_type, :string
    add_column :spotlights, :image_file_size, :integer
    add_column :spotlights, :image_updated_at, :datetime
    add_column :spotlights, :image_alt, :string
  end

  def self.down
    remove_column :spotlights, :image_file_name
    remove_column :spotlights, :image_content_type
    remove_column :spotlights, :image_file_size
    remove_column :spotlights, :image_updated_at
    remove_column :spotlights, :image_alt
  end
end
