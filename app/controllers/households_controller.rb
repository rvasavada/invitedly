class HouseholdsController < ApplicationController
  before_action :set_household, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :verify_occasion_ownership
  
  def new
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @response = ResponseType.all
    @title = Title.all
    @household = current_user.households.new
    
    @guests = @household.guests.build
  end

  def edit
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @response = ResponseType.all
    @title = Title.all
  end
  
  def create
    @household = current_user.households.new(household_params)
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    @household.guests.each do |guest|
      guest.user_id = current_user.id
    end
    
    @invitation = @household.build_invitation
    @invitation.occasion_id = @occasion.id
    
    if @household.save
      redirect_to occasion_invitations_path(@occasion), notice: 'Household was successfully created.'
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
    
    @household.guests.each do |guest|
      guest.user_id = current_user.id
    end
    
    if @household.update(household_params)
      redirect_to occasion_invitations_path(@occasion), notice: 'Household was successfully updated.'
    else      
      @response = ResponseType.all
      @title = Title.all

      render action: 'edit' 
    end
  end
  
  def destroy
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    @household.destroy
    redirect_to occasion_invitations_path(@occasion), notice: 'Household was successfully deleted.'
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_household
      @household = Household.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def household_params
      params.require(:household).permit(:name, :email, :notes, invitation_attributes: [:id, :occasion_id,:guest_id,:status,:code,:send_email,:send_date,:send_reminder,:include_gift_option], guests_attributes: [:id, :email, :notes, :user_id, :guest_id, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :household_name, :cell_phone, :home_phone, :title, :first_name, :last_name, :_destroy, rsvps_attributes: [:id, :visibility, :message, :num_guests, :event_id, :response]])
    end
  
end
