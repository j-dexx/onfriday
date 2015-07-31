class Document < ActiveRecord::Base

  has_attached_file :document, 
    :url => "/assets/stored_documents/:style/:id_:basename.:extension",
    :path => ":rails_root/public/assets/stored_documents/:style/:id_:basename.:extension"
    
  validates_attachment_presence :document
  
  named_scope :newest, :order => "created_at DESC"

end
