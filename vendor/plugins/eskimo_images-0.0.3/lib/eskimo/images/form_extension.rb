module Eskimo::Images::FormExtension

  def image_field_tag(form, object, image, options={})
    render "admin/form/image_field_tag", :form => form, :object => object, :image => image, :options => options
  end
    
end
