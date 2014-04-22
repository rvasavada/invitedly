class SignUpController < ApplicationController
  
  include Wicked::Wizard
  steps :wedding_info, :event_info

  def show
    @user = current_user
    
    case step
    when :wedding_info
      @occasion = @user.build_occasion
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
    when :wedding_info
      @occasion = @user.build_occasion(occasion_params)
      @occasion.save
    when :event_info
      @invitation.status = "Responded"
      @invitation.update(invitation_params)
    when :guestbook
      @invitation.update(invitation_params)
    end
    
    render_wizard @occasion
    
  end
  
  private

    # Never trust parameters from the scary internet, only allow the white list through
    def occasion_params
      params.require(:occasion).permit(:name, :description, :slug)
    end
end
