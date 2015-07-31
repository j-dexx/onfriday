module Eskimo::Tables::HelperExtension

  def self.included(base)
    ActionView::Base.send :include, ClassMethods
  end
  
  module ClassMethods
  
    def eskimo_table(locals_in, table_id = 'table')
      defaults = {
                   :admin => true,
                   :manual_sorting => false,
                   :drag_handle => 'Name', 
                   :menu => true, 
                   :sorting => true, 
                   :paging => true,
                   :notes => false,
                   :edit_action => "edit",
                   :delete_action => "destroy",
                   :delete_message => "Are you sure?",
                   :show_action => nil,
                   :order_action => "order",
                   :highlight => nil,
                   :lowlight => lambda{|x| !x.display? },
                   :css_class => nil,
                   :images => false
                 }
      columns = locals_in[:columns].map do |column|
        if column.kind_of?(String) or column.kind_of?(Symbol)
          column = column.to_s
          if column.split("_").last == "id"
            cname = column.gsub("_id", "")
            [cname.split("_").map{|w| w.capitalize}.join(" "), lambda{|o| o.send(cname) ? o.send(cname).name : ""}, column]
          else
            [column.split("_").map{|w| w.capitalize}.join(" "), column, column]
          end
        else
          column
        end
      end
      locals = defaults.merge(locals_in).merge(:columns => columns, :table_id => table_id)
      if locals[:list].length > 0
        #if locals[:manual_sorting]
        #  render :partial => 'tables/admin_table_sort', :locals => locals
        #else
        #  render :partial => 'tables/admin_table', :locals => locals
        #end
        render :partial => 'tables/eskimo_table', :locals => locals
      else
        render :partial => "tables/no_items"
      end
    end

    def admin_table(locals_in, render_table = 'admin/shared/admin_table', table_id = 'table')
      if render_table == 'admin/shared/admin_table_sort' || locals_in[:manual_sorting] == true
        locals = locals_in.merge(:manual_sorting => true)
      elsif render_table == 'admin/shared/admin_table'
        locals = locals_in.merge(:manual_sorting => false)
      end
      eskimo_table(locals)
    end

  end
  
end
