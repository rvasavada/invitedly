class OccasionsController < ApplicationController
  before_action :set_occasion, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:edit, :new]
  before_filter :verify_owner, only: [:edit]
  
  def index
    @occasions = current_user.occasions
  end

  def show
    if @occasion.blank?
      raise ActionController::RoutingError.new('Not Found')
    else
      @title = Title.all
      
      @invitations = @occasion.invitations.where("message IS NOT NULL AND length(message) > 0")
      @events = @occasion.events
      
    
      @invitation = @occasion.invitations.build
      @invitation.guests.build
    
      @country = Country.all
      @state = State.all
      if (params[:first_name].present? || params[:last_name].present?)
        guests = User.find(@occasion.user_id).guests.where("LOWER(first_name) LIKE ? AND LOWER(last_name) LIKE ?",  "%#{params[:first_name].downcase}%", "%#{params[:last_name].downcase}%")
        @guests = []
        for guest in guests
          if guest.household.invitations.where(:occasion_id => @occasion.id).present?
            @guests.push(guest)
          end
        end
      end
    end
  end

  def new
    @occasion = current_user.occasions.build
  end

  def edit
  end

  def create
    @occasion = current_user.occasions.build(occasion_params)
    
    if @occasion.save
      redirect_to new_occasion_event_path(@occasion), notice: 'Great!  Your occasion was saved.  Now, let\'s add some events...'
    else
      render action: 'new'
    end
  end

  def update
    if @occasion.update(occasion_params)
      redirect_to occasion_invitations_path(@occasion), notice: 'Occasion was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @occasion.destroy
    respond_to do |format|
      format.html { redirect_to occasions_url, notice: 'Occasion was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_occasion
      @occasion = Occasion.find_by_slug(params[:id])
      Rails.logger.debug(@occasion.inspect)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def occasion_params
      params.require(:occasion).permit(:name, :description, :slug)
    end
    
    def verify_owner
      if params[:id].present?
        @occasion = Occasion.find_by_slug(params[:id])
        unless current_user == @occasion.user || current_user == User.find(1)
          redirect_to root_url, alert: "Sorry, you're not allowed to see that page!"
        end
      end
    end
end
