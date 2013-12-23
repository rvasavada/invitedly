class RsvpController < ApplicationController
  include Wicked::Wizard

  steps :contact_info, :invitations, :confirmation
  
  def show
    case step
    when :contact_info
    when :invitations
    when :confirmation
      @friends = @user.find_friends
    end
    render_wizard
  end
  
end
