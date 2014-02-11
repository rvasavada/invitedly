class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :verify_occasion_ownership, only: [:index]
  
  def index
    @occasion = Occasion.friendly.find(params[:occasion_id]) 
    @invitations = @occasion.invitations
    
    respond_to do |format|
      format.html
      format.csv { send_data @invitations.to_csv(@occasion) }
    end
  end
  
  def new
    @occasion = Occasion.friendly.find(params[:occasion_id]) 
    @title = Title.all
    
    @invitation = @occasion.invitations.build
    @household = current_user.households.new
    @guest = @household.guests.build
    @rsvps = []
    @occasion.events.each do |event|
      @rsvps.push(Rsvp.new(:event_id => event.id))
    end
  end
  
  def edit
    @occasion = Occasion.friendly.find(params[:occasion_id]) 
    
    @title = Title.all
    @household = @invitation.household
    @guests = @household.guests
    
    @guests.each do |guest|
      (@occasion.events - guest.events).each do |event|
        guest.rsvps.build(:event_id => event.id)
      end
    end
    
    @rsvps = []
    @occasion.events.each do |event|
      @rsvps.push(Rsvp.new(:event_id => event.id))
    end
    
  end
  
  def create
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    @invitation = @occasion.invitations.new(invitation_params)
    current_user.household.new()
    @invitation.household.user_id = current_user.id
    
    @invitation.guests.each do |guest|
      guest.user_id = current_user.id
    end
    
    if @invitation.save
      redirect_to occasion_invitations_path(@occasion), notice: 'Invitation was successfully created.'
    else
      @title = Title.all
      render action: 'new'
    end
  end
  
  def update
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @invitation.household.user_id = current_user.id
    
    @invitation.guests.each do |guest|
      guest.user_id = current_user.id
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
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    @invitation.destroy
    redirect_to occasion_invitations_path(@occasion), notice: 'Invitation was successfully deleted.'
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
