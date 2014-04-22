class Users::RegistrationsController < Devise::RegistrationsController
  def edit
    @state = State.all
    @title = Title.all
    @country = Country.all
  end
  
  protected

  def after_sign_up_path_for(resource)
    sign_up_path
  end
end