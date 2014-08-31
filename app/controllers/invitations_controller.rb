class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:edit, :update, :destroy]
  before_action :set_occasion
  
  before_filter :authenticate_user!, except: [:new, :create]
  before_filter :verify_occasion_ownership, only: [:index,:new,:edit]
  
  def index
    if params[:status].present?
      @invitations = @occasion.invitations.where("status = ?", params[:status])
    elsif params[:tag].present?
      @invitations = @occasion.invitations.tagged_with(params[:tag])
    elsif params[:q].present?
      q = "%#{params[:q]}%"
      @invitations = @occasion.invitations.where("lower(name) ILIKE lower(?)",q)
    else
      @invitations = @occasion.invitations
    end    

    respond_to do |format|
      format.html
      format.csv { send_data @invitations.to_csv(@occasion) }
    end
  end
  
  def new
    @title = Title.all
    
    @invitation = @occasion.invitations.build
    @invitation.guests.build
    @events = @occasion.events
    @country = Country.all
    @state = State.all
  end
  
  def edit
    @title = Title.all
    @events = @occasion.events
    @country = Country.all
    @state = State.all
  end
   
  def create
    @invitation = @occasion.invitations.new(invitation_params)
    @invitation.user_id = @occasion.user_id
    @invitation.status = "Not Sent"
    if @invitation.save
      if
        redirect_to @occasion, notice: 'Thanks for giving us your contact info.  We\'ll be sure to send you an invite!'
      else 
        redirect_to occasion_invitations_path(@occasion), notice: 'Invitation was successfully created.'
      end
    else
      @title = Title.all
      @state = State.all
      @country = Country.all
      @events = @occasion.events
      
      render action: 'new'
    end
  end
  
  def update
    if @invitation.update(invitation_params)
      redirect_to occasion_invitations_path(@occasion), notice: 'Invitation was successfully updated.'
    else      
      @title = Title.all
      @state = State.all
      @country = Country.all
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
  
  def send_invitation
    invitation = Invitation.friendly.find(params[:invitation_id])
    if invitation.status == "Not Sent"
      InvitationMailer.email_invitation(current_user, @occasion, invitation)
      invitation.status = "Not Responded"
    end
    
    if invitation.save
      render :js=>'alert("Invitation sent!");'
    else
      render :js=>'alert("Whoops!  An error occured.  Please try again.");'
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:message, :name, :email, :has_email, :notes, :tag_list, :address_1, 
          :address_2, :city, :state, :zip, :country, :region, :postal_code, :cell_phone, :home_phone,
          guests_attributes: [:id, :title, :first_name, :last_name, :is_child, :is_additional_guest, :_destroy, rsvps_attributes: [:id, :event_id, :visibility]])
    end
  
end
