class SignUpController < ApplicationController
  include Wicked::Wizard
  steps :host_info, :wedding_info, :event_info

  def show
    @user = current_user
    
    case step
    when :host_info
    when :wedding_info
      if @user.occasion.present?
        @occasion = @user.occasion
      else
        @occasion = @user.build_occasion
      end
    when :event_info
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
    when :host_info
    when :wedding_info
      @occasion = @user.build_occasion(occasion_params)
      @occasion.save
    when :event_info
      @country = Country.all
      @state = State.all
      
      @occasion = @user.occasion
      @occasion.update(occasion_params)
    end
    
    render_wizard @occasion
    
  end
  
  private

    # Never trust parameters from the scary internet, only allow the white list through
    def occasion_params
      params.require(:occasion).permit(:name, :description, :slug, events_attributes: [:name, :description, :start_date, :start_time, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :location, :slug, :_destroy])
    end
end
