class Admin::<%= plural_class_name %>Controller < Admin::AdminController
  <%= admin_controller_methods :admin_actions %>
end