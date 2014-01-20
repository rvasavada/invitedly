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
    @title = Title.all.order("name ASC")
    #@country = Country.all.order("name ASC")
    #@state = State.all.order("name ASC")
    
  end

  def edit
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
