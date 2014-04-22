class SignUpController < ApplicationController
  
  include Wicked::Wizard
  steps :create_occasion, :create_events, :create_invitations

  def show
    @user = current_user
    
    case step
    when :create_occasion
      @occasion = Occasion.new
    when :create_events
      @events = @occasion.events
    when :create_invitations
    end
    render_wizard
  end
  
  def update
    @invitation = Invitation.friendly.find(params[:invitation_id])

    case step
    when :guest_info
      @invitation.update(invitation_params)
      @title = Title.all
    when :events
      @invitation.status = "Responded"
      @invitation.update(invitation_params)
    when :guestbook
      @invitation.update(invitation_params)
    when :confirmation
    end
    
    render_wizard @invitation
    
  end
  
  def verify_first_last_name
    if (params[:first_name].present? || params[:last_name].present?)
      guests = User.find(@occasion.user_id).guests.where("LOWER(first_name) LIKE ? AND LOWER(last_name) LIKE ?",  "%#{params[:first_name].downcase}%", "%#{params[:last_name].downcase}%")
      @guests = []
      for guest in guests
        if guest.household.invitations.where(:occasion_id => @occasion.id).present?
          @guests.push(guest)
        end
      end
            
      if @guests.blank?
        redirect_to occasion_path(@occasion, first_name: params[:first_name], last_name: params[:last_name]), alert: "No guests found."
      else
        redirect_to occasion_path(@occasion, first_name: params[:first_name], last_name: params[:last_name]), notice: "Now, select a guest to RSVP!"
      end
    else
      redirect_to occasion_path(@occasion, first_name: params[:first_name], last_name: params[:last_name]), alert: "Please enter a first or last name!"
    end
  end
  
  
  def verify_email_address
    

    unless params[:email].blank?
      @guest = Guest.find_by_email(params[:email])
      if @guest.blank?
        redirect_to @occasion, :notice => "Sorry, you entered an unrecognized email address!"
      else
        if @guest.invitation.blank?
          redirect_to @occasion, :notice => "Sorry, you entered an unrecognized email address!"
        else 
          redirect_to occasion_invitation_rsvp_path(@occasion, @guest.invitation, :guest_info)
        end
      end
    else
      redirect_to occasion_path(@occasion), :notice => "Please enter an email address!"
    end
  end
  
  private

    # Never trust parameters from the scary internet, only allow the white list through
    def invitation_params
      params.require(:invitation).permit(:message, :status,
        rsvps_attributes: [:id, :response],
        household_attributes: [:id, :title, :first_name, :last_name, :email, 
          guests_attributes: [:id, :title, :first_name, :last_name]])
    end
end
