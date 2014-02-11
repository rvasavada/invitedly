class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  
  before_filter :authenticate_user!
  before_filter :verify_occasion_ownership
  
  def index
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @response = ResponseType.all
    
    @events = @occasion.events
  end

  def show
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @event = Event.friendly.find(params[:id])
    
    @invites = @event.rsvps
    @attending = @invites.where(:response => "Attending")
    @might_attend = @invites.where(:response => "Might Attend")
    @not_attend = @invites.where(:response => "Not Attending")
    @not_responded = @invites.where(:response => "Not Responded")
  end

  def new
    @country = Country.all.order("name ASC")
    @state = State.all.order("name ASC")
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @event = @occasion.events.new
  end

  def edit
    @country = Country.all.order("name ASC")
    @state = State.all.order("name ASC")
    @occasion = Occasion.friendly.find(params[:occasion_id])
  end

  def create
    @occasion = Occasion.friendly.find(params[:occasion_id])
    params[:event][:start_time] = DateTime.parse(params[:event][:start_time])   
    @event = @occasion.events.new(event_params)
    if @event.save
      unless params[:commit] == "Save & Add more" 
        redirect_to occasion_events_path(@occasion), notice: 'Event was successfully created.'
      else
        redirect_to new_occasion_event_path(@occasion), notice: 'Event was successfully created.' 
      end
    else
      @country = Country.all.order("name ASC")
      @state = State.all.order("name ASC")
      render action: 'new' 
    end
  end

  def update
    @occasion = Occasion.friendly.find(params[:occasion_id])    
    params[:event][:start_time] = DateTime.parse(params[:event][:start_time])
    if @event.update(event_params)
      unless params[:commit] == "Save & Add more" 
        redirect_to occasion_events_path(@occasion), notice: 'Event was successfully updated.'
      else
        redirect_to new_occasion_event_path(@occasion), notice: 'Event was successfully updated.'
      end
    else
      @country = Country.all.order("name ASC")
      @state = State.all.order("name ASC")
      render action: 'edit' 
    end
  end

  def destroy
    @occasion = Occasion.friendly.find(params[:occasion_id])    
    
    @event.destroy
    respond_to do |format|
      format.html { redirect_to occasion_events_path(@occasion)}
      format.json { render :json => {id: @event.id, response: "Event was deleted."} }
    end
  end

  def manage_guestlist
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @event = Event.friendly.find(params[:event_id])
    @guests = current_user.guests
    @uninvited = @event.guests 
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end
  
  def destroy_invites
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @event = Event.friendly.find(params[:event_id])
    params[:guest_ids].each do |guest|
      @event.invitations.where(guest_id: guest).destroy_all
    end
    redirect_to occasion_event_path(@occasion,@event), notice: 'Invitations were successfully deleted.'
  end
    
  def update_invites
    @occasion = Occasion.friendly.find(params[:occasion_id])
    if params[:event_id].present?
      @event = Event.friendly.find(params[:event_id])
      invitations = []
      params[:guest_ids].each do |guest|

        invitations << Invitation.new(event_id: @event.id, guest_id: guest, num_guests: Guest.find(guest).max_guests, response: "Not Responded")
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
