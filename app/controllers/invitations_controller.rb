class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_occasion_ownership, only: [:index]
  def index
    @occasion = Occasion.friendly.find(params[:occasion_id]) 
    @invitations = @occasion.invitations
  end
  
end
