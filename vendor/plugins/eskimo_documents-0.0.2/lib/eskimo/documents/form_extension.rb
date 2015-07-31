module Eskimo::Documents::FormExtension

  def document_field_tag(form, object, document, options={})
    render "admin/form/document_field_tag", :form => form, :object => object, :document => document, :options => options
  end
    
end
