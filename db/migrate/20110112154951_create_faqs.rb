class CreateFaqs < ActiveRecord::Migration
  def self.up
    create_table :faqs do |t|
      t.text :question
      t.text :answer
      
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
    drop_table :faqs
  end
end
