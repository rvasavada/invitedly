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
    @household.guests.build
    @events = @occasion.events
    @event_invites = ''
  end
  
  def edit
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @title = Title.all

    @events = @occasion.events
    @event_invites = params[:events].blank? ? '' : params[:events]
  end
   
  def create
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    @invitation = @occasion.invitations.new(invitation_params)
    @invitation.household.user_id = current_user.id
    @event_invites = params[:events].blank? ? [] : params[:events]
    @event_uninvites = @occasion.events - @event_invites
    
    @invitation.household.guests.each do |guest|
      @event_invites.each do |event|
        guest.rsvps.new(:event_id => event.to_i)
        guest.user_id = current_user.id
      end
      @event_uninvites.each do |event|
        rsvp = guest.rsvps.find_by_event_id(event.id)
        rsvp.destroy if rsvp
      end
    end
    
    if @invitation.save
      redirect_to occasion_invitations_path(@occasion), notice: 'Invitation was successfully created.'
    else
      @title = Title.all
      @events = @occasion.events
      
      render action: 'new'
    end
  end
  
  def update
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @invitation.household.user_id = current_user.id
    @event_invites = @occasion.events.find(params[:events])
    @event_uninvites = @occasion.events - @event_invites
    
    @invitation.household.guests.each do |guest|
      @event_invites.each do |event|
        guest.rsvps.find_or_create_by_event_id(event.id)
        guest.user_id = current_user.id
      end
      @event_uninvites.each do |event|
        guest.rsvps.find_by_event_id(event.id).destroy
      end
    end

    if @invitation.update(invitation_params)
      redirect_to occasion_invitations_path(@occasion), notice: 'Invitation was successfully updated.'
    else      
      @title = Title.all
      @events = @occasion.events
      
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
        household_attributes: [:id, :name, :email, :notes, :tag_list,
          guests_attributes: [:id, :title, :first_name, :last_name, :_destroy]])
    end
  
end
