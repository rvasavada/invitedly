class InvitationMailer < ActionMailer::Base
  
  def send_all_reminders(user, occasion)
    @user = user
    @occasion = occasion
    
    invitations = occasion.invitations - occasion.invitations.where(:status => 'Responded')
    invitations.each do |invitation|
      @invitation = invitation
      if invitation.household.email.present?
        mail(:to => "#{invitation.household.email}", :subject => "RSVP reminder: #{@occasion.name}", :from => "Invitedly <notifications@invitedly.com>", :reply_to => "<#{@user.email}>").deliver
      end
    end
    
  end
end