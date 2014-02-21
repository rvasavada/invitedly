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
      @events = @occasion.events
      @household = @invitation.household
      @guests = @household.guests
      
      @rsvps = @household.rsvps
      
    when :rsvp
    end
    render_wizard
  end
  
  def update
    @invitation = Invitation.friendly.find(params[:invitation_id])
    @invitation.update_attributes(params[:invitation])
    
    render_wizard @invitation
  end
end