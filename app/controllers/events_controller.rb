class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @event = params[:event].blank? ? nil : Event.friendly.find(params[:event])
    @response = ResponseType.where(:active => true)
    
    @events = @occasion.events
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @event = Event.friendly.find(params[:id])
    
    @invites = @event.invitations
    @attending = @invites.where(:response => "Attending")
    @might_attend = @invites.where(:response => "Might Attend")
    @not_attend = @invites.where(:response => "Not Attending")
    @not_responded = @invites.where(:response => "Not Responded")
  end

  # GET /events/new
  def new
    @country = Country.all.order("name ASC")
    @state = State.all.order("name ASC")
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @event = @occasion.events.new
  end

  # GET /events/1/edit
  def edit
    @country = Country.all.order("name ASC")
    @state = State.all.order("name ASC")
    @occasion = Occasion.friendly.find(params[:occasion_id])
  end

  # POST /events
  # POST /events.json
  def create
    @occasion = Occasion.friendly.find(params[:occasion_id])    
    @event = @occasion.events.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { 
          unless params[:commit] == "Save & Add another event" 
            redirect_to occasion_event_path(@occasion,@event), notice: 'Event was successfully created.'
          else
            redirect_to new_occasion_event_path, notice: 'Event was successfully created.' 
          end
        }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { 
          @country = Country.all.order("name ASC")
          @state = State.all.order("name ASC")
          render action: 'new' 
        }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @occasion = Occasion.friendly.find(params[:occasion_id])    
    
    respond_to do |format|
      if @event.update(event_params)
        format.html { 
          unless params[:commit] == "Save & Add another event" 
            redirect_to occasion_event_path(@occasion,@event), notice: 'Event was successfully updated.'
          else
            redirect_to new_occasion_event_path(@occasion), notice: 'Event was successfully updated.'
          end
        }
        format.json { head :no_content }
      else
        format.html { 
          @country = Country.all.order("name ASC")
          @state = State.all.order("name ASC")
          render action: 'edit' 
        }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { render :json => {id: @event.id, response: "Event was deleted."} }
    end
  end
  
  def invite_guests
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @event = Event.friendly.find(params[:event_id])
    @contacts = current_user.contacts
    @uninvited = @contacts - @event.contacts 
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

  def manage_guestlist
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @event = Event.friendly.find(params[:event_id])
    @contacts = current_user.contacts
    @uninvited = @event.contacts 
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end
  
  def destroy_invites
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @event = Event.friendly.find(params[:event_id])
    params[:guest_ids].each do |guest|
      @event.invitations.where(contact_id: guest).destroy_all
    end
    redirect_to occasion_event_path(@occasion,@event), notice: 'Invitations were successfully deleted.'
  end
    
  def update_invites
    @occasion = Occasion.friendly.find(params[:occasion_id])
    if params[:event_id].present?
      @event = Event.friendly.find(params[:event_id])
      invitations = []
      params[:guest_ids].each do |guest|

        invitations << Invitation.new(event_id: @event.id, contact_id: guest, num_guests: Contact.find(guest).max_guests, response: "Not Responded")
      end
      Invitation.import invitations
      redirect_to occasion_event_path(@occasion,@event), notice: 'Invitations were successfully created.'
    else
      @invitations= Invitation.update(params[:invitations].keys, params[:invitations].values).reject { |p| p.errors.empty? }
      redirect_to :back, notice: 'Invitations were successfully updated.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :description, :occasion_id, :start_date, :start_time, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :location, :slug)
    end
end
