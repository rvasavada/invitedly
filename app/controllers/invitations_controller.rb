class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]

  def index
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @invitations = @occasion.invitations
  end

  def show
  end

  def new
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @guest = Contact.find_by_id(params[:guest_id])
    
    @contacts = current_user.contacts - @occasion.contacts
    
    
    
    @invitation = Invitation.new(:contact_id => params[:guest_id])
    @occasion.events.each do |event|
      @invitation.rsvps.build(:event_id => event.id)
    end
  end

  def edit
  end

  def create
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @contacts = current_user.contacts
    
    @invitation = Invitation.new(invitation_params)
    @invitation.occasion_id = @occasion.id
    @invitation.status = "Not sent"
    @guest = Contact.find(@invitation.contact_id)
    @invitation.rsvps.each do |rsvp|
      if rsvp.response == "1"
        rsvp.response == "Not Responded"
        rsvp.contact_id = @invitation.contact_id
        rsvp.num_guests = @guest.max_guests
        rsvp.user_id = current_user.id
        rsvp.occasion_id = @occasion.id
      else 
        rsvp.destroy
      end
    end
    
    if @invitation.save
      unless params[:commit] == "Save & Add more" 
        redirect_to occasion_invitations_path(@occasion), notice: 'Invitation was successfully created.'
      else
        redirect_to new_occasion_invitation_path(@occasion), notice: 'Invitation was successfully created.'
      end
    else
      @guest = Contact.find_by_id(params[:guest_id])
      render action: 'new' 
    end

  end

  # PATCH/PUT /invitations/1
  # PATCH/PUT /invitations/1.json
  def update
    respond_to do |format|
      if @invitation.update(invitation_params)
        format.html { redirect_to @invitation, notice: 'Invitation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to invitations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:occasion_id,:contact_id,:status,:code,:send_email,:send_date,:send_reminder,:include_gift_option, rsvps_attributes: [:event_id, :response])
    end
end
