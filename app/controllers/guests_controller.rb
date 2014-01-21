class GuestsController < ApplicationController
  before_action :set_guest, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!

  def index
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @guests = current_user.guests
  end

  def new
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @guest = Guest.new
    @response = ResponseType.all
    @title = Title.all
        
    @occasion.events.each do |event|
      @guest.rsvps.build(:event_id => event.id)
    end
  end

  def edit
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @response = ResponseType.all
    @title = Title.all
  end

  def create
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @guest = current_user.guests.new(guest_params)

    @invitation = @guest.build_invitation
    @invitation.occasion_id = @occasion.id
    
    if @guest.save
      redirect_to occasion_guests_path(@occasion), notice: 'Guest was successfully created.'
    else
      @response = ResponseType.all
      @title = Title.all
      @country = Country.all
      @state = State.all
      render action: 'new'
    end
  end

  def update
    @occasion = Occasion.friendly.find(params[:occasion_id])
      
    if @guest.update(guest_params)
      redirect_to occasion_guests_path(@occasion), notice: 'Guest was successfully created.'
    else      
      @response = ResponseType.all
      @title = Title.all
      @country = Country.all
      @state = State.all
      render action: 'edit' 
    end
  end

  def destroy
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    @guest.destroy
    redirect_to occasion_guests_path(@occasion), notice: 'Guest was successfully deleted.' 
  end

  def get_facebook_guests
    session[:login_refresh] = false
    
     @rest = Koala::Facebook::GraphAndRestAPI.new(current_user.facebook_token)
     fql = "select uid,first_name,last_name,sex from user where uid in (select uid2 from friend where uid1=me())"      
     @guests = @rest.fql_query(fql)
          
     @guests.each do |guest|
       title = nil 
       if guest['sex'] == "male"
         title = "Mr."
       elsif guest['sex'] == "female"
         title = "Ms."
       end
       Guest.find_or_create_by(user_id: current_user.id, facebook_uid: guest['uid'],
                    :household_name => "#{title} #{guest['first_name']} #{guest['last_name']}",
                    :user_id => current_user.id)       
     end
     
     redirect_to address_book_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guest
      @guest = Guest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guest_params
      params.require(:guest).permit(:email, :notes, :user_id, :guest_id, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :household_name, :cell_phone, :home_phone, :title, :first_name, :last_name, :is_family, guests_attributes: [:id, :title, :first_name, :last_name, :_destroy], rsvps_attributes: [:id, :guest_id, :visibility, :message, :event_id, :response], invitation_attributes: [:id, :occasion_id,:guest_id,:status,:code,:send_email,:send_date,:send_reminder,:include_gift_option])
    end
end
