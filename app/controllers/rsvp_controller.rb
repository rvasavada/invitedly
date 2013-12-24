class RsvpController < ApplicationController
  include Wicked::Wizard
  layout false

  steps :contact_info, :invitations, :confirmation
  
  def show
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @contact = Contact.find_by_id(params[:contact_id])

    case step
    when :contact_info
      @country = Country.all.order("name ASC")
      @state = State.all.order("name ASC")
    when :invitations

      @response = ResponseType.all
    
    when :confirmation
    end
    render_wizard
  end
  
  def update
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @contact = Contact.find_by_id(params[:contact_id])
    
    case step
    when :contact_info
      @country = Country.all.order("name ASC")
      @state = State.all.order("name ASC")
      @contact.update(contact_params)
    when :invitations
     @contact = Contact.find_by_id(params[:contact][:id])
     @contact.update(contact_params)
     
     @invitations = @contact.invitations
     
     /Invitation.find_by_sql("SELECT invitations.* FROM invitations
        INNER JOIN events ON invitations.event_id = events.id
        INNER JOIN contacts ON contacts.id = invitations.contact_id
        WHERE events.occasion_id = '#{@occasion.id}'
          AND contacts.id = #{@contact.id}")
       /
     @response = ResponseType.all
     render_wizard @contact   
    when :confirmation
    end
    render_wizard(@contact, :contact_id => @contact)
    
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit( 
        :email, 
        :notes, 
        :user_id, 
        :contact_id, 
        :address_1, 
        :address_2, 
        :city, 
        :state, 
        :zip, 
        :country, 
        :region, 
        :postal_code, 
        :household_name, 
        :cell_phone, 
        :home_phone, 
        :max_guests,
        invitations_attributes: [:id, :event_id, :response,:num_guests,:message])
    end
  
end
