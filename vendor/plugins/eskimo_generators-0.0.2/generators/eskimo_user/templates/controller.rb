class <%= plural_class_name %>Controller < ApplicationController

  before_filter :validate_<%= singular_name %>, :only => [:index, :edit, :update]
  
  def index
  
  end

  def new
    @<%= singular_name %> = <%= class_name %>.new
  end  

  def create
    @<%= singular_name %> = <%= class_name %>.new(params[:<%= singular_name %>])
    if @<%= singular_name %>.save
      flash[:notice] = "Successfully registered."
      redirect_to <%= plural_name %>_path  
    else
      render :action => 'new'
    end
  end  

  def edit  
    @<%= singular_name %> = current_<%= singular_name %>  
  end  
    
  def update  
    @<%= singular_name %> = current_<%= singular_name %>
    if @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])  
      flash[:notice] = "Successfully updated profile."  
      redirect_to root_url
    else  
      render :action => 'edit'  
    end  
  end   
  
end
