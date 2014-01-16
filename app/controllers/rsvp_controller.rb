class RsvpsController < ApplicationController
  include Wicked::Wizard

  steps :select_guests, :select_events, :invitation_details, :verify, :confirmation

  def show
    @user = current_user
    @occasion = Occasion.friendly.find(params[:occasion_id])
    case step
    when :select_guests
      @contacts = @user.contacts
    when :select_events
      @events = @occasion.events
      
    when :invitation_details
    when :verify
    when :confirmation
    end
    render_wizard
  end
end
