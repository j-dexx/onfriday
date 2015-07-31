  def order
    params[:draggable].each_with_index do |id, index|
      <%= class_name %>.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end