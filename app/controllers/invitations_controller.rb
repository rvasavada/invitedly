class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :verify_occasion_ownership, only: [:index]
  
  def index
    @occasion = Occasion.friendly.find(params[:occasion_id]) 
    @invitations = @occasion.invitations
  end
  
  def new
    @occasion = Occasion.friendly.find(params[:occasion_id]) 
    
    @response = ResponseType.all
    @title = Title.all
    @invitation = @occasion.invitations.build
    
    if params[:type] == "household"
      @invitable = current_user.households.new
      @household.guests.build
    else
      @invitable = current_user.guests.new
    end
  end
  
  def edit
    @occasion = Occasion.friendly.find(params[:occasion_id]) 
    
    @response = ResponseType.all
    @title = Title.all
    @invitable = @invitation.invitable
  end
  
  def create
  end
  
  def update
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    
    
    if @invitation.update(invitation_params)
      redirect_to occasion_invitations_path(@occasion), notice: 'Invitation was successfully updated.'
    else      
      @response = ResponseType.all
      @title = Title.all
      @invitable = @invitation.invitable
      
      render action: 'edit' 
    end
  end
  
  def destroy
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:message, 
        rsvps_attributes: [:id, :response], 
        invitable_attributes: [:id, :name, :title, :first_name, :last_name, :email, 
          guests_attributes: [:id, :title, :first_name, :last_name]])
    end
  
end
