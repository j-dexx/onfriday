class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table "documents", :force => true do |t|
      t.timestamps
      t.integer   :created_by
      t.integer   :updated_by
      t.string    :document_content_type
      t.string    :document_file_name
      t.integer   :document_file_size
      t.datetime  :document_updated_at
    end
  end

  def self.down
    drop_table "images"
  end
end
