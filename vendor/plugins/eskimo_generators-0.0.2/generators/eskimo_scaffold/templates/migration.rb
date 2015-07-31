class Create<%= plural_class_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= plural_name %> do |t|
    <%- for attribute in attributes -%>
      t.<%= attribute.type %> :<%= attribute.name %>
    <%- end -%>
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