class InvitationMailer < ActionMailer::Base
  
  def send_all_reminders(user, occasion)
    @user = user
    @occasion = occasion
    
    invitation = @occasion.invitations.where("response != 'Responded' OR response is nil")
    mail(:to => "Rhut Vasavada <rhut@vasvada.us>", :subject => "RSVP reminder: #{@occasion.name}", :from => "<#{@user.email}>")
    #mail(:to => "#{user.full_name} <#{user.email}>", :subject => "Thanks for using Forget.ly!", :from => "Forgetly <notifications@forget.ly>")
  end
end