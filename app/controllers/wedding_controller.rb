class WeddingController < ApplicationController
  include Wicked::Wizard
  steps :info, :about_the_couple, :get_started

  def show
    @user = current_user
    
    case step
    when :info
    when :about_the_couple
      @title = Title.all
      @country = Country.all
      @state = State.all
    when :get_started
    end

    render_wizard
  end
  
  def update
    @user = current_user

    case step
    when :info
      @user.update(user_params)
      
    when :about_the_couple
      @user.update(user_params)
      
      @title = Title.all
      @country = Country.all
      @state = State.all
    when :get_started
    end
    
    render_wizard @user
    
  end
  
  private

    # Never trust parameters from the scary internet, only allow the white list through
    def user_params
      params.require(:user).permit(occasion_attributes: [:id, :name, :description, :slug])
    end
end
