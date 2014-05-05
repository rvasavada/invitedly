class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  protected
  
  def verify_occasion_ownership
    if params[:occasion_id].present?
      @occasion = Occasion.find_by_slug(params[:occasion_id])
      unless current_user == @occasion.user || current_user == Occasion.find(1)
        redirect_to root_url, alert: "Sorry, you're not allowed to see that page!"
      end
    end
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_occasion
    if params[:occasion_id].present?
      @occasion = Occasion.find_by_slug(params[:occasion_id])
    end
  end
end
