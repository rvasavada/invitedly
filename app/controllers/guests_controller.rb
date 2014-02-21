class GuestsController < ApplicationController
  before_action :set_occasion

  def import
    if params[:file].present?
      Guest.import(params[:file],@occasion,current_user)
      redirect_to occasion_invitations_path(@occasion), notice: "Guests imported."
    else
      redirect_to occasion_invitations_path(@occasion), alert: "Please import a CSV file!"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guest
      @guest = Guest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guest_params
      params.require(:guest).permit(:email, :notes, :user_id, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :cell_phone, :home_phone, :title, :first_name, :last_name, rsvps_attributes: [:id, :visibility, :message, :event_id, :response], invitation_attributes: [:id, :occasion_id,:status,:code,:send_email,:send_date,:send_reminder,:include_gift_option])
    end
end
