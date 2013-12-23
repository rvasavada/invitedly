class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = current_user.contacts
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = current_user.contacts.new
    
    @response = ResponseType.all
    @title = Title.all.order("name ASC")
    @country = Country.all.order("name ASC")
    @state = State.all.order("name ASC")
  end

  # GET /contacts/1/edit
  def edit
    @response = ResponseType.all
    @title = Title.all.order("name ASC")
    @country = Country.all.order("name ASC")
    @state = State.all.order("name ASC")
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = current_user.contacts.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { 
          unless params[:commit] == "Save & Add another contact" 
            redirect_to address_book_path, notice: 'contact was successfully created.'
          else
            redirect_to new_contact_path, notice: 'Contact was successfully created.' 
          end
        }
        format.json { render action: 'show', status: :created, location: @contact }
      else
        format.html { 
          @response = ResponseType.all
          @title = Title.all.order("name ASC")
          @country = Country.all.order("name ASC")
          @state = State.all.order("name ASC")
          render action: 'new' 
        }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { 
          unless params[:commit] == "Save & Add another contact" 
            redirect_to address_book_path, notice: 'Contact was successfully updated.'
          else
            redirect_to new_contact_path, notice: 'Contact was successfully updated.' 
          end
        }
        format.json { head :no_content }
      else
        format.html { 
          @response = ResponseType.all
          @title = Title.all.order("name ASC")
          @country = Country.all.order("name ASC")
          @state = State.all.order("name ASC")
          render action: 'edit' 
        }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { render :json => {id: @contact.id, response: "Guest was deleted."} }
    end
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
                    :max_guests => 1,
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
      params.require(:contact).permit(:email, :notes, :user_id, :contact_id, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :household_name, :cell_phone, :home_phone, :max_guests)
    end
end
