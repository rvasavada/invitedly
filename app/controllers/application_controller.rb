class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  protected
  
  def verify_occasion_ownership
    @occasion = Occasion.friendly.find(params[:occasion_id])
    unless current_user.id == @occasion.user_id
      redirect_to root_url, alert: "Sorry, you're not allowed to see that page!"
    end
  end
end
