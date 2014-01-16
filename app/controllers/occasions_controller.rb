class OccasionsController < ApplicationController
  before_action :set_occasion, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:edit, :new]

  def index
    @occasions = current_user.occasions
  end

  def show
    unless user_signed_in? and @occasion.user_id == current_user.id and params[:preview] != "true"
      @contact = User.find(@occasion.user_id).contacts.new

      @response = ResponseType.all
      @title = Title.all.order("name ASC")
      @country = Country.all.order("name ASC")
      @state = State.all.order("name ASC")
      render "home",  :layout => 'wedding_page'
    end
  end

  def new
    if current_user.occasion.present?
      redirect_to current_user.occasion, notice: 'Sorry, you can\'t have more than one wedding...yet!'
    end
    @occasion = Occasion.new
  end

  def edit
  end

  def create
    @occasion = Occasion.new(occasion_params)
    @occasion.user_id = current_user.id
    if @occasion.save
      redirect_to new_occasion_event_path(@occasion), notice: 'Great!  Your occasion was saved.  Now, let\'s add some events...'
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
  
  
  #to create a list of guests and select which ones to invite
  def invite_guests
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @contacts = current_user.contacts
    @uninvited = @contacts
    respond_to do |format|
      format.html
      format.js { render :layout => false }
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
