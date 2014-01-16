class ContactsController < ApplicationController
  before_action :set_contact, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:index, :edit, :new]

  def index
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    @contacts = current_user.contacts
  end

  def new
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @contact = current_user.contacts.new
    @invitation = @contact.build_invitation
    @occasion.events.each do |event|
      @invitation.rsvps.build(:event_id => event.id)
    end
        
    @response = ResponseType.all
    @title = Title.all.order("name ASC")
    @country = Country.all.order("name ASC")
    @state = State.all.order("name ASC")
  end

  def edit
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    @response = ResponseType.all
    @title = Title.all.order("name ASC")
    @country = Country.all.order("name ASC")
    @state = State.all.order("name ASC")
  end

  def create
    @contact = current_user.contacts.new(contact_params)
    @contact.total_guest_count = @contact.guests.count + 1
    @occasion = Occasion.friendly.find(params[:occasion_id])

    @invitation = @contact.invitation
    @invitation.occasion_id = @occasion.id
    @invitation.status = "Not sent"
    @invitation.rsvps.each do |rsvp|
      rsvp.num_guests = @contact.total_guest_count
      rsvp.user_id = current_user.id
      rsvp.occasion_id = @occasion.id
    end
    
    if @contact.save
      unless params[:commit] == "Save & Add more" 
        redirect_to occasion_contacts_path(@occasion), notice: 'Guest was successfully created.'
      else
        redirect_to new_occasion_contact_path(@occasion), notice: 'Guest was successfully created.' 
      end
    else
      @response = ResponseType.all
      @title = Title.all.order("name ASC")
      @country = Country.all.order("name ASC")
      @state = State.all.order("name ASC")
      render action: 'new' 
    end
  end

  def update
    @contact.total_guest_count = @contact.guests.count + 1
    @occasion = Occasion.friendly.find(params[:occasion_id])
      
    if @contact.update(contact_params)
      unless params[:commit] == "Save & Add more" 
        redirect_to occasion_contacts_path(@occasion), notice: 'Guest was successfully updated.'
      else
        redirect_to new_occasion_contact_path(@occasion), notice: 'Guest was successfully updated.' 
      end
    else      
      @response = ResponseType.all
      @title = Title.all.order("name ASC")
      @country = Country.all.order("name ASC")
      @state = State.all.order("name ASC")
      render action: 'edit' 
    end
  end

  def destroy
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    @contact.destroy
    redirect_to occasion_contacts_path(@occasion), notice: 'Guest was successfully deleted.' 
  end

  def get_facebook_contacts
    session[:login_refresh] = false
    
     @rest = Koala::Facebook::GraphAndRestAPI.new(current_user.facebook_token)
     fql = "select uid,first_name,last_name,sex from user where uid in (select uid2 from friend where uid1=me())"      
     @contacts = @rest.fql_query(fql)
          
     @contacts.each do |contact|
       title = nil 
       if contact['sex'] == "male"
         title = "Mr."
       elsif contact['sex'] == "female"
         title = "Ms."
       end
       Contact.find_or_create_by(user_id: current_user.id, facebook_uid: contact['uid'],
                    :household_name => "#{title} #{contact['first_name']} #{contact['last_name']}",
                    :user_id => current_user.id)       
     end
     
     redirect_to address_book_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:email, :notes, :user_id, :contact_id, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :household_name, :cell_phone, :home_phone, :title, :first_name, :last_name, :is_family, guests_attributes: [:id, :title, :first_name, :last_name, :_destroy], invitation_attributes: [:occasion_id,:contact_id,:status,:code,:send_email,:send_date,:send_reminder,:include_gift_option, rsvps_attributes: [:id, :visibility, :message, :num_guests, :event_id, :response]])
    end
end
