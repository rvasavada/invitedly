class RsvpController < ApplicationController
  include Wicked::Wizard
  layout "wedding_page"
  steps :guest_info, :events, :confirmation

  def show
    @invitation = Invitation.friendly.find(params[:invitation_id])
    @guest = @invitation.guest
    @occasion = Occasion.friendly.find(params[:occasion_id])
    case step
    when :guest_info
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
    @guest = @invitation.guest
    @occasion = Occasion.friendly.find(params[:occasion_id])
    case step
    when :guest_info
      @guest.total_guest_count = @guest.guests.count + 1
      
      @guest.update(guest_params)

    when :events
      @guest.update(guest_params)
    when :confirmation
    end
    render_wizard @guest
  end
  
  def verify_email_address
    
    @occasion = Occasion.friendly.find(params[:occasion_id])
    unless params[:email].blank?
      @guest = Guest.find_by_email(params[:email])
      if @guest.blank?
        if params[:preview] == "true"
          redirect_to occasion_path(@occasion, :preview=> true), :notice => "Sorry, you entered an unrecognized email address!"
        else
          redirect_to @occasion, :notice => "Sorry, you entered an unrecognized email address!"
        end
      else
        if @guest.invitation.blank?
          if params[:preview] == "true"
            redirect_to occasion_path(@occasion, :preview=> "true"), :notice => "Sorry, you entered an unrecognized email address!"
          else
            redirect_to @occasion, :notice => "Sorry, you entered an unrecognized email address!"
          end
        else 
          redirect_to occasion_invitation_rsvp_path(@occasion, @guest.invitation, :guest_info)
        end
      end
    else
      if params[:preview] == "true"
        redirect_to occasion_path(@occasion, :preview=> true), :notice => "Please enter a email address!"
      else
        redirect_to @occasion, :notice => "Please enter a email address!"
      end
    end
  end
  
  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def guest_params
      params.require(:guest).permit(:email, :notes, :user_id, :guest_id, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :household_name, :cell_phone, :home_phone, :title, :first_name, :last_name, :is_family, guests_attributes: [:id, :title, :first_name, :last_name, :_destroy], invitation_attributes: [:id, :occasion_id,:guest_id,:status,:code,:send_email,:send_date,:send_reminder,:include_gift_option, rsvps_attributes: [:id, :visibility, :message, :num_guests, :event_id, :response]])
    end
  
end
