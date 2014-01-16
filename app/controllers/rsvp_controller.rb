class RsvpController < ApplicationController
  include Wicked::Wizard

  steps :contact_info, :invitation, :confirmation

  def show
    @contact = Contact.find(params[:contact_id])
    @occasion = Occasion.friendly.find(params[:occasion_id])
    case step
    when :contact_info
      @title = Title.all.order("name ASC")
      @country = Country.all.order("name ASC")
      @state = State.all.order("name ASC")
    when :invitation
      @response = ResponseType.all
      
    when :confirmation
    end
    render_wizard
  end
  
  def update
    @contact = Contact.find(params[:contact_id])
    @occasion = Occasion.friendly.find(params[:occasion_id])
    case step
    when :contact_info
      @contact.total_guest_count = @contact.guests.count + 1
      
      @contact.update(contact_params)

    when :invitation
    when :confirmation
    end
    render_wizard @contact
  end
  
  def verify_email_address
    @occasion = Occasion.friendly.find(params[:occasion_id])
    unless params[:email].blank?
      @contact = Contact.find_by_email(params[:email])
      redirect_to occasion_contact_rsvp_path(@occasion, @contact, :contact_info)
    else
      redirect_to @occasion, :notice => "Sorry, you entered an invalid email address!"
    end
  end
  
  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:email, :notes, :user_id, :contact_id, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :household_name, :cell_phone, :home_phone, :title, :first_name, :last_name, :is_family, guests_attributes: [:id, :title, :first_name, :last_name, :_destroy], invitation_attributes: [:occasion_id,:contact_id,:status,:code,:send_email,:send_date,:send_reminder,:include_gift_option, rsvps_attributes: [:id, :visibility, :message, :num_guests, :event_id, :response]])
    end
  
end
