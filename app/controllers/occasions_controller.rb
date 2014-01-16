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
      render "home"
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
    @occasion.user_id = current_user
    
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
  
  
  #useless one
  def begin_rsvp_flow
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @contact = Contact.find_by_id(params[:contact_id])
    if @contact.blank?
      redirect_to :back, :notice => "Sorry, you entered an invalid code!"
    else
      redirect_to occasion_rsvp_path(@occasion, :contact_info, :contact_id => @contact)
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
