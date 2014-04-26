class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:edit, :update, :destroy]
  before_action :set_occasion
  
  before_filter :authenticate_user!
  before_filter :verify_occasion_ownership, only: [:index,:new,:edit]
  
  def index
    @invitations = @occasion.invitations.includes(:rsvps)

    respond_to do |format|
      format.html
      format.csv { send_data @invitations.to_csv(@occasion) }
    end
  end
  
  def new
    @title = Title.all
    
    @invitation = @occasion.invitations.build
    @invitation.guests.build
    
    @country = Country.all
    @state = State.all
  end
  
  def show
    @invitation = Invitation.friendly.find(params[:invitation_id])
    
    case step
    when :guest_info
      @title = Title.all
    when :events
    when :rsvp
    end
    render_wizard
  end
   
  def create
    @invitation = @occasion.invitations.new(invitation_params)
    @invitation.user_id = current_user.id
    
    if @invitation.save
      redirect_to occasion_invitation_manage_path(@occasion, @invitation, :events), notice: 'Invitation was successfully created.'
    else
      @title = Title.all
      @state = State.all
      @country = Country.all
      @events = @occasion.events
      
      render action: 'new'
    end
  end
  
  def update
    @invitation.household.user_id = current_user.id
    @event_invites = @occasion.events.find(params[:events])
    @event_uninvites = @occasion.events - @event_invites
    
    @invitation.household.guests.each do |guest|
      @event_invites.each do |event|
        guest.rsvps.find_or_create_by_event_id(event.id)
        guest.user_id = current_user.id
      end
      @event_uninvites.each do |event|
        rsvp = guest.rsvps.find_by_event_id(event.id)
        rsvp.destroy if rsvp
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
    
    @invitation.destroy
    redirect_to occasion_invitations_path(@occasion), notice: 'Invitation was successfully deleted.'
  end
  
  def popover
    render :layout => nil
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:message, :name, :email, :notes, :tag_list,
          guests_attributes: [:id, :title, :first_name, :last_name, :_destroy])
    end
  
end
