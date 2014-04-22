class Users::SessionsController < Devise::SessionsController

protected
  def after_sign_in_path_for(resource)
    
    if current_user.occasion.blank?
      sign_up_path(:create_occasion)
    else
      occasion_invitations_path(current_user.occasions.last)
    end
  end
end