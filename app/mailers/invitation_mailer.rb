class InvitationMailer < ActionMailer::Base
  
  def email_invitation(user, occasion, invitation)
    @user = user
    @occasion = occasion
    @invitation = invitation
    mail(:to => "#{invitation.email}", 
         :subject => "#{user.first_name} and #{user.partner_first_name} invite you to: #{occasion.name}", 
         :from => "Invitedly <notifications@invitedly.com>", 
         :reply_to => "<#{user.email}>").deliver
  end
  
  def email_invitation_reminder(user, occasion)
    @user = user
    @occasion = occasion
    
    invitations = occasion.invitations - occasion.invitations.where(:status => 'Responded')
    invitations.each do |invitation|
      @invitation = invitation
      mail(:to => "#{invitation.email}", :subject => "RSVP reminder: #{@occasion.name}", :from => "Invitedly <notifications@invitedly.com>", :reply_to => "<#{@user.email}>").deliver
    end
    
  end
end