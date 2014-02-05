class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_invitation_ownership
  def index
    @occasion = Occasion.friendly.find(params[:occasion_id]) 
    @invitations = @occasion.invitations
  end
  
  protected
  
  def verify_invitation_ownership
    @occasion = Occasion.friendly.find(params[:occasion_id])
    unless current_user.id == @occasion.user_id
      redirect_to root_url, alert: "Sorry, you're not allowed to see that page!"
    end
  end
end
