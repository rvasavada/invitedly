class OccasionsController < ApplicationController
  before_action :set_occasion, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:index, :edit, :new]

  def index
    @occasions = current_user.occasions
  end

  def show
    if user_signed_in? and @occasion.user_id == current_user.id and params[:preview] != "true"
      @events = @occasion.events
      @guests = Contact.find_by_sql("SELECT contacts.* FROM contacts
         INNER JOIN events ON invitations.event_id = events.id
         INNER JOIN invitations ON contacts.id = invitations.contact_id
         WHERE events.occasion_id = '#{@occasion.id}'
           AND contacts.user_id = #{current_user.id}
         ORDER BY lower(household_name) ASC").uniq
      @response = ResponseType.all
    else
      render "rsvp/login", :layout => false
    end
  end

  def new
    @occasion = Occasion.new
  end

  def edit
  end

  def create
    @occasion = current_user.occasions.new(occasion_params)

    if @occasion.save
      redirect_to @occasion, notice: 'Occasion was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @occasion.update(occasion_params)
      redirect_to @occasion, notice: 'Occasion was successfully updated.'
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
      @occasion = Occasion.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def occasion_params
      params.require(:occasion).permit(:name, :description, :slug)
    end
end
