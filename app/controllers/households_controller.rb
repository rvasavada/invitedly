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

    #@response = ResponseType.all
    @title = Title.all.load
    
  end

  def edit
  end
  
  def create
    @household = current_user.households.new(household_params)
    @occasion = Occasion.friendly.find(params[:occasion_id])

    if @household.save
      unless params[:commit] == "Save & Add more" 
        redirect_to occasion_guests_path(@occasion), notice: 'Household was successfully created.'
      else
        redirect_to new_occasion_guest_path(@occasion), notice: 'Household was successfully created.' 
      end
    else
      @response = ResponseType.all
      @title = Title.all
      @country = Country.all
      @state = State.all
      render action: 'new' 
    end
  end

  def update
    @guest.total_guest_count = @guest.guests.count + 1
    @occasion = Occasion.friendly.find(params[:occasion_id])
      
    if @guest.update(guest_params)
      unless params[:commit] == "Save & Add more" 
        redirect_to occasion_guests_path(@occasion), notice: 'Guest was successfully updated.'
      else
        redirect_to new_occasion_guest_path(@occasion), notice: 'Guest was successfully updated.' 
      end
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
    def guest_params
      params.require(:household).permit(:name, :total_guests)
    end
  
end
