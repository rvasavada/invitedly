class Users::SessionsController < Devise::SessionsController
  after_filter :clear_sign_signout_flash, :only => [:create, :destroy]
protected
  def clear_sign_signout_flash
    if flash.keys.include?(:notice)
      flash.delete(:notice)
    end
  end
  
  def after_sign_in_path_for(resource)
   occasions_path
  end
end