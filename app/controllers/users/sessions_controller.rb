class Users::SessionsController < Devise::SessionsController

protected
  def after_sign_in_path_for(resource)
    if current_user.occasion.blank?
      new_occasion_path
    else
      current_user.occasion
    end
  end
end