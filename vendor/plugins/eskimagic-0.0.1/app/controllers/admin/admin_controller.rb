class Admin::AdminController < ApplicationController

  layout "admin"
  
  before_filter :authorize_administrator
  before_filter :check_permissions

  def check_for_site_maintenance
    # do nothing, since this is an admin page, needs to be here though, to override the front end method
  end
  
  def authorize_administrator
    # if the admin is logged in or they are only accessing the admin_sessions controller let them continue
    unless current_administrator || params[:controller] == "admin/administrator_sessions"
      flash[:error] = "You must login to view this content."
      redirect_to admin_login_path
      return
    end
    @current_administrator = current_administrator # publish to admin views
  end
  
  def check_permissions
    if current_administrator
      unless current_administrator.has_permission?(params[:controller], params[:action])
        flash[:error] = "You do not have permission to access this admin function."
        redirect_to admin_path
        return
      end
    end
  end
  
  def set_parent_and_position(klass, parent, sortable)
    sortable.each do |pos, hash|
      id = hash.delete("id")
      klass.update(id, {:position => pos.to_i + 1, :parent_id => parent})
      set_parent_and_position(klass, id, hash)
    end
  end
  
  def set_order(klass, sortable)
    sortable.each_with_index do |id, index|
      klass.update_all(['position=?', index+1], ['id=?', id])
    end
  end

end
