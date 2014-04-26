class WeddingController < ApplicationController
  include Wicked::Wizard
  steps :info, :about_the_couple, :get_started

  def show
    @user = current_user
    
    case step
    when :info
      if @user.occasion.present?
        @occasion = @user.occasion
      else
        @occasion = @user.build_occasion
      end
    when :about_the_couple
      @title = Title.all
      @country = Country.all
      @state = State.all
    when :get_started
      @occasion = @user.occasion
      @event = @occasion.events.new
      @country = Country.all
      @state = State.all
    end
    render_wizard
  end
  
  def update
    @user = current_user

    case step
    when :info
      @user.update(user_params)
      @title = Title.all
      @country = Country.all
      @state = State.all
    when :about_the_couple
      @user.update(user_params)
    when :get_started
      @user.update(user_params)
      @country = Country.all
      @state = State.all
    end
    
    render_wizard @user
    
  end
  
  private

    # Never trust parameters from the scary internet, only allow the white list through
    def user_params
      params.require(:user).permit(occasion_attributes: [:name, :description, :slug, events_attributes: [:name, :description, :start_date, :start_time, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :location, :slug, :_destroy]])
    end
end
