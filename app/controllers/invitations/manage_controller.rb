class Invitations::ManageController < ApplicationController
  include Wicked::Wizard
  before_action :set_occasion

  steps :guest_info, :rsvp
  
  def show
    @invitation = Invitation.friendly.find(params[:invitation_id])
    case step
    when :guest_info
      @title = Title.all
      @country = Country.all
      @state = State.all
    when :rsvp
      @guests = @invitation.guests
      @events = @occasion.events
      
      for guest in @guests
        for event in @occasion.events
          guest.rsvps.find_or_create_by(event_id: event.id, invitation_id: @invitation.id)
        end
      end
    end
    render_wizard
  end
  
  def update
    @invitation = Invitation.friendly.find(params[:invitation_id])

    case step
    when :guest_info
      @invitation.update(invitation_params)
      @title = Title.all
      @country = Country.all
      @state = State.all
    when :rsvp
      @invitation.update(invitation_params)
      
      @guests = @invitation.guests
      for guest in @guests
        for event in @occasion.events
          guest.rsvps.find_or_initialize_by_event_id(event.id)
        end
      end
    end
    
    render_wizard @invitation
    
  end

  private
  
  def finish_wizard_path
    occasion_invitations_path(@occasion)
  end  
  # Never trust parameters from the scary internet, only allow the white list through.
  def invitation_params
    params.require(:invitation).permit(:name, :has_email, :email, :notes, :tag_list, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :cell_phone, :home_phone, rsvps_attributes: [:id, :visibility, :response], guests_attributes: [:id, :title, :first_name, :last_name, :_destroy,  :is_child, :is_additional_guest])
  end
end