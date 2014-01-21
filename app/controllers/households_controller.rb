class HouseholdsController < ApplicationController
  before_action :set_household, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!
  
  def new
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @household = current_user.households.new
    @invitation = @household.build_invitation
    @occasion.events.each do |event|
      @invitation.rsvps.build(:event_id => event.id)
    end

    @title = Title.all.load
  end

  def edit
  end
  
  def create
    @household = current_user.households.new(household_params)
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    #@invitation = @guest.invitation
    #@invitation.occasion_id = @occasion.id
    
    if @household.save
      redirect_to occasion_guests_path(@occasion), notice: 'Household was successfully created.'
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
      redirect_to occasion_guests_path(@occasion), notice: 'Household was successfully updated.'
    else      
      @response = ResponseType.all
      @title = Title.all.order("name ASC")
      @country = Country.all.order("name ASC")
      @state = State.all.order("name ASC")
      render action: 'edit' 
    end
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_household
      @household = Household.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def household_params
      params.require(:household).permit(:name, :total_guests, guests_attributes: [:email, :notes, :user_id, :guest_id, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :household_name, :cell_phone, :home_phone, :title, :first_name, :last_name, :is_family, invitation_attributes: [:id, :occasion_id,:guest_id,:status,:code,:send_email,:send_date,:send_reminder,:include_gift_option, rsvps_attributes: [:id, :visibility, :message, :num_guests, :event_id, :response]]])
    end
  
end
