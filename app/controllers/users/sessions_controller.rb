class Users::SessionsController < Devise::SessionsController
  # DELETE /resource
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    respond_to_on_destroy

#    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
#    set_flash_message :notice, :destroyed if is_flashing_format?
#    yield resource if block_given?
#    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end
end
