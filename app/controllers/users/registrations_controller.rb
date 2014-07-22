class Users::RegistrationsController < Devise::RegistrationsController
  def edit
    @state = State.all
    @title = Title.all
    @country = Country.all
  end
  
  def new
    @user = User.new
    @state = State.all
    @title = Title.all
    @country = Country.all
  end
  
  def create
    
        @user = User.new(user_params)
        if @user.save
            wedding_path(:info)
        else
          @country = Country.all
          @state = State.all
          @title = Title.all
          @country = Country.all
          render action: 'new' 
        end
  end
  
  protected

  def after_sign_up_path_for(resource)
    
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :title, :first_name, :last_name, :partner_title, :partner_first_name, :partner_last_name, :address_1, :address_2, :city, :state, :region, :zip, :postal_code, :country, :cell_phone, :home_phone)
  end
end