class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]

  def index
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @invitations = @occasion.invitations
  end

  def show
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @guest = Contact.find(@invitation.contact_id)
    
  end

  def new
    @occasion = Occasion.friendly.find(params[:occasion_id])  
    @contacts = current_user.contacts - @occasion.contacts
    @response = ResponseType.all

    @invitation = Invitation.new
    @occasion.events.each do |event|
      @invitation.rsvps.build(:event_id => event.id)
    end
  end

  def edit
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @contacts = @occasion.contacts

    @response = ResponseType.all

  end

  def create
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    @invitation = Invitation.new(invitation_params)
    @invitation.occasion_id = @occasion.id
    @invitation.status = "Not sent"
    @guest = Contact.find(@invitation.contact_id)
    @invitation.rsvps.each do |rsvp|
      rsvp.response = "Not Responded"
      rsvp.contact_id = @guest.id
      rsvp.num_guests = @invitation.max_guests
      rsvp.user_id = current_user.id
      rsvp.occasion_id = @occasion.id
    end
    
    if @invitation.save
      unless params[:commit] == "Save & Invite more" 
        redirect_to occasion_invitations_path(@occasion), notice: 'Invitation was successfully created.'
      else
        redirect_to new_occasion_invitation_path(@occasion), notice: 'Invitation was successfully created.'
      end
    else
      @contacts = current_user.contacts - @occasion.contacts
      render action: 'new' 
    end

  end

  # PATCH/PUT /invitations/1
  # PATCH/PUT /invitations/1.json
  def update
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    if @invitation.update(invitation_params)
      unless params[:commit] == "Save & Invite more" 
        redirect_to occasion_invitations_path(@occasion), notice: 'Invitation was successfully updated.'
      else
        redirect_to new_occasion_invitation_path(@occasion), notice: 'Invitation was successfully updated.'
      end
    else
      @contacts = @occasion.contacts
      @guest = Contact.find(@invitation.contact_id)
      @response = ResponseType.all
      
      render action: 'edit' 
    end
    
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation.destroy
    
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    redirect_to occasion_invitations_path(@occasion)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:occasion_id,:contact_id,:status,:code,:send_email,:send_date,:send_reminder,:include_gift_option, rsvps_attributes: [:id, :visibility, :message, :num_guests, :event_id, :response])
    end
end
