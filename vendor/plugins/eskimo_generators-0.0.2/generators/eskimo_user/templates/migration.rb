class Create<%= plural_class_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= plural_name %> do |t|
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.datetime :last_login_at
      t.string :perishable_token, :default => ""
      
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
