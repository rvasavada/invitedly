class InvitationsController < ApplicationController
  
  def index
    @occasion = Occasion.friendly.find(params[:occasion_id]) 
    @invitations = @occasion.invitations
  end

end
