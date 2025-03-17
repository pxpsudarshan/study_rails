class Users::SessionsController < Devise::SessionsController
  layout 'devise'
  helper :all

  private 
  
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || menus_path
  end
end