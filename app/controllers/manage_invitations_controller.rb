class ManageInvitationsController < ApplicationController
  include Wicked::Wizard
  prepend_before_filter :set_steps

  steps :select_events, :select_guests
  
  def show
    @occasion = Occasion.friendly.find(params[:occasion_id])
    render_wizard
  end
  
  private
  
  def set_steps
    if params[:guests].present? 
      self.steps = [:select_events]
    elsif params[:events].present?
      self.steps = [:select_guests]
    end
  end
  
end
