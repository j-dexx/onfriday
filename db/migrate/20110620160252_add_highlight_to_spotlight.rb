class AddHighlightToSpotlight < ActiveRecord::Migration
  def self.up
    add_column :spotlights, :highlight, :boolean, :default => false
  end

  def self.down
    remove_column :spotlights, :highlight
  end
end
