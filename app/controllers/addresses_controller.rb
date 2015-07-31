class AddressesController < ApplicationController

  def edit
    @address = Address.find(params[:id])
    unless @address.user == current_user
      flash[:error] = "You do not have permission to edit this resource." 
      redirect_to edit_user_path(current_user)    
      return
    end
  end  

  def update
    @address = Address.find(params[:id])
    unless @address.user == current_user
      flash[:error] = "You do not have permission to edit this resource." 
      redirect_to edit_user_path(current_user)    
      return
    end
    if @address.update_attributes(params[:promo_code])
      flash[:notice] = "Successfully updated address."
      redirect_to edit_user_path(current_user)
    else
      render :action => 'edit'
    end
  end  

  def destroy
    @address = Address.find(params[:id])
    unless @address.user == current_user
      flash[:error] = "You do not have permission to edit this resource." 
      redirect_to edit_user_path(current_user)    
      return
    end
    @address.destroy
    flash[:notice] = "Successfully destroyed address."
    redirect_to edit_user_path(current_user)
  end
  
end
