class ManageInvitationsController < ApplicationController
  include Wicked::Wizard
  prepend_before_filter :set_steps

  steps :select_events, :select_guests
  
  def show
    @occasion = Occasion.friendly.find(params[:occasion_id])
    case step
    when :select_guests
      @event = Event.friendly.find(params[:event])
      @contacts = current_user.contacts
      @contacts.each do |contact|
        @event.invitations.find_or_initialize_by(contact_id: contact.id)
      end
    end
    
    render_wizard
  end
  
  def update
    @occasion = Occasion.friendly.find(params[:occasion_id])    
    @event = Event.friendly.find(params[:id])    

    if @event.update(event_params)
      redirect_to occasion_event_path(@occasion, event), notice: 'Invitations were successfully updated.'
    end    
  end
  
  private
  
  def set_steps
    if params[:guest].present? 
      self.steps = [:select_events]
    elsif params[:event].present?
      self.steps = [:select_guests]
    end
  end
  
end
