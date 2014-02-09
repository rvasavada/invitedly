class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :verify_occasion_ownership, only: [:index]
  
  def index
    @occasion = Occasion.friendly.find(params[:occasion_id]) 
    @invitations = @occasion.invitations
  end
  
  def new
    @occasion = Occasion.friendly.find(params[:occasion_id]) 
    
    @response = ResponseType.all
    @title = Title.all
    @invitation = @occasion.invitations.build
    
    @household = current_user.households.new
    @household.guests.build
    
    @occasion.events.each do |event|
      @invitation.rsvps.build(:event_id => event.id)      
    end
    
    @rsvps = @invitation.rsvps
  end
  
  def edit
    @occasion = Occasion.friendly.find(params[:occasion_id]) 
    
    @response = ResponseType.all
    @title = Title.all
    @household = @invitation.household
    @guests = @household.guests
    
    @guests.each do |guest|
      (@occasion.events - guest.events).each do |event|
        guest.rsvps.build(:event_id => event.id)
      end
    end
    
  end
  
  def create
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    @invitation = @occasion.invitations.new(invitation_params)

    if @invitation.save
      redirect_to occasion_invitations_path(@occasion), notice: 'Invitation was successfully created.'
    else
      @response = ResponseType.all
      @title = Title.all
      render action: 'new'
    end
  end
  
  def update
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @invitation.household.rsvps.each do |rsvp|
      rsvp.invitation_id = @invitation.id
    end

    if @invitation.update(invitation_params)
      redirect_to occasion_invitations_path(@occasion), notice: 'Invitation was successfully updated.'
    else      
      @response = ResponseType.all
      @title = Title.all
      @household = @invitation.household
      
      (@occasion.events-@invitation.events).each do |event|
        @invitation.rsvps.build(:event_id => event.id)      
      end
    
      @rsvps = @invitation.rsvps
      
      render action: 'edit' 
    end
  end
  
  def destroy
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:message,
        household_attributes: [:id, :name, :email, :notes,
          guests_attributes: [:id, :title, :first_name, :last_name, :_destroy,
          rsvps_attributes: [:id, :event_id, :visibility, :response, :invitation_id]]])
    end
  
end
