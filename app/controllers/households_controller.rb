class HouseholdsController < ApplicationController
  before_action :set_household, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!
  
  def new
  end

  def edit
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_household
      @household = Household.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guest_params
      params.require(:household).permit(:name, :total_guests)
    end
  
end
