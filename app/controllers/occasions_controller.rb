class OccasionsController < ApplicationController
  before_action :set_occasion, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:edit, :new]
  before_filter :verify_ownership, only: [:edit, :new]

  def index
    @occasions = current_user.occasions
  end

  def show    
    if (params[:first_name].present? || params[:last_name].present?)
      @guests = User.find(@occasion.user_id).guests.where("LOWER(first_name) LIKE ? AND LOWER(last_name) LIKE ?",  "%#{params[:first_name].downcase}%", "%#{params[:last_name].downcase}%")
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
  
  def guestbook
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @invitations = @occasion.invitations.where("message IS NOT NULL OR message != ''")
  end
  
  protected
  
    def verify_ownership
      @occasion = Occasion.friendly.find(params[:id])
      unless current_user.id == @occasion.user_id
        redirect_to root_url, alert: "Sorry, you're not allowed to see that page!"
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
