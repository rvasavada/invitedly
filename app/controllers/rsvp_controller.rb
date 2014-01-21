class RsvpController < ApplicationController
  include Wicked::Wizard
  layout "wedding_page"
  steps :guest_info, :events, :confirmation

  def show
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @invitation = Invitation.friendly.find(params[:invitation_id])
    
    if @invitation.invitable_type == "Household"
      @household = Household.find(@invitation.invitable_id)
    else
      @guest = Guest.find(@invitation.invitable_id)
    end
    
    case step
    when :guest_info
      @title = Title.all
      @country = Country.all
      @state = State.all
    when :events
      @response = ResponseType.all
    when :confirmation
    end
    render_wizard
  end
  
  def update
    @invitation = Invitation.friendly.find(params[:invitation_id])
    @occasion = Occasion.friendly.find(params[:occasion_id])
    case step
    when :guest_info
      if @invitation.invitable_type == "Household"
        @household = Household.find(@invitation.invitable_id)
        @household.update(guest_params)
      else
        @guest = Guest.find(@invitation.invitable_id)
        @guest.update(guest_params)
      end
    when :events
      if @invitation.invitable_type == "Household"
        @household = Household.find(@invitation.invitable_id)
        @household.update(guest_params)
      else
        @guest = Guest.find(@invitation.invitable_id)
        @guest.update(guest_params)
      end
    when :confirmation
    end
    render_wizard @guest
  end
  
  def verify_first_last_name
    
    @occasion = Occasion.friendly.find(params[:occasion_id])
    unless params[:first_name].blank? && params[:last_name].blank?
      full_name = "#{params[:first_name]} #{params[:last_name]}"
      @guests = []
      @guests = @occasion.guests
      #.find(['first_name LIKE ? OR last_name LIKE ?', "%#{params[:first_name]}}%","%#{params[:last_name]}}%" ])
      
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
      params.require(:guest).permit(:email, :notes, :user_id, :guest_id, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :household_name, :cell_phone, :home_phone, :title, :first_name, :last_name, :is_family, rsvps_attributes: [:id, :visibility, :message, :num_guests, :event_id, :response])
    end
  
end
