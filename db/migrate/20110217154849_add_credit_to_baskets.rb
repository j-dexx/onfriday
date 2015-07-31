class AddCreditToBaskets < ActiveRecord::Migration
  def self.up
    add_column :baskets, :credit, :float, :default => 0
  end

  def self.down
    remove_column :baskets, :credit
  end
end
