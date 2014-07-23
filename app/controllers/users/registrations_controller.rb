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
    
    @occasion = @user.build_occasion
  end
  
  def create  
    @user = User.new(user_params)
    Rails.logger.debug(@user.save.inspect)
    if @user.save
      redirect_to new_occasion_event_path(@user.occasion), notice: 'Great!  Your occasion was saved.  Now, let\'s add some events...'
    else
      @state = State.all
      @title = Title.all
      @country = Country.all
      render action: 'new' 
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :title, :first_name, :last_name, :partner_title, :partner_first_name, :partner_last_name, :address_1, :address_2, :city, :state, :region, :zip, :postal_code, :country, :cell_phone, :home_phone, occasion_attributes: [:name, :description])
  end
end