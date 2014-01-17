class RsvpController < ApplicationController
  include Wicked::Wizard
  layout "wedding_page"
  steps :contact_info, :events, :confirmation

  def show
    @invitation = Invitation.friendly.find(params[:invitation_id])
    @contact = @invitation.contact
    @occasion = Occasion.friendly.find(params[:occasion_id])
    case step
    when :contact_info
      @title = Title.all.order("name ASC")
      @country = Country.all.order("name ASC")
      @state = State.all.order("name ASC")
    when :events
      @response = ResponseType.all
      
    when :confirmation
    end
    render_wizard
  end
  
  def update
    @invitation = Invitation.friendly.find(params[:invitation_id])
    @contact = @invitation.contact
    @occasion = Occasion.friendly.find(params[:occasion_id])
    case step
    when :contact_info
      @contact.total_guest_count = @contact.guests.count + 1
      
      @contact.update(contact_params)

    when :events
      @contact.update(contact_params)
    when :confirmation
    end
    render_wizard @contact
  end
  
  def verify_email_address
    @occasion = Occasion.friendly.find(params[:occasion_id])
    unless params[:email].blank?
      @contact = Contact.find_by_email(params[:email])
      if @contact.blank?
        redirect_to @occasion, :notice => "Sorry, you entered an invalid email address!"
      else
        if @contact.invitation.blank?
          redirect_to @occasion, :notice => "Sorry, this is awkward.  You haven't been invited!"
        else 
          redirect_to occasion_invitation_rsvp_path(@occasion, @contact.invitation, :contact_info)
        end
      end
    else
      redirect_to @occasion, :notice => "Please enter a email address.!"
    end
  end
  
  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:email, :notes, :user_id, :contact_id, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :household_name, :cell_phone, :home_phone, :title, :first_name, :last_name, :is_family, guests_attributes: [:id, :title, :first_name, :last_name, :_destroy], invitation_attributes: [:id, :occasion_id,:contact_id,:status,:code,:send_email,:send_date,:send_reminder,:include_gift_option, rsvps_attributes: [:id, :visibility, :message, :num_guests, :event_id, :response]])
    end
  
end