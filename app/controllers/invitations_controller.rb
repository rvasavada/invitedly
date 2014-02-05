class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @occasion = Occasion.friendly.find(params[:occasion_id]) 
    @invitations = @occasion.invitations
  end

end
