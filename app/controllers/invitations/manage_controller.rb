class Invitations::ManageController < ApplicationController
  include Wicked::Wizard
  before_action :set_occasion

  steps :guest_info, :events, :rsvp
  
  def show
    @invitation = Invitation.friendly.find(params[:invitation_id])
    case step
    when :guest_info
      @title = Title.all
    when :events
      @household = @invitation.household
      @guests = @household.guests
      
      for guest in @household.guests
        for event in @occasion.events
          guest.rsvps.find_or_initialize_by(event_id: event.id, invitation_id: @invitation.id)
        end
      end
    when :rsvp
      @events = @occasion.events
      
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
      @invitation.update(invitation_params)
      
      @household = @invitation.household
      @guests = @household.guests
      for guest in @household.guests
        for event in @occasion.events
          guest.rsvps.find_or_initialize_by_event_id(event.id)
        end
      end
    when :rsvp
      @invitation.update(invitation_params)
    end
    
    render_wizard @invitation
    
  end

  private
  
  def finish_wizard_path
    occasion_invitations_path(@occasion)
  end  
  # Never trust parameters from the scary internet, only allow the white list through.
  def invitation_params
    params.require(:invitation).permit(rsvps_attributes: [:id, :response],
      household_attributes: [:id, :name, :email, :notes, :tag_list,
        guests_attributes: [:id, :title, :first_name, :last_name, :_destroy,
          rsvps_attributes: [:id, :visibility, :invitation_id, :event_id]]])
  end
end