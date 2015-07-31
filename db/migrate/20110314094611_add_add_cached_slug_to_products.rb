class AddAddCachedSlugToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :cached_slug, :string
  end

  def self.down
    remove_column :products, :cached_slug
  end
end
