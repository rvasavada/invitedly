class OccasionsController < ApplicationController
  before_action :set_occasion, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:index, :edit, :new]

  # GET /occasions
  # GET /occasions.json
  def index
    @occasions = current_user.occasions
  end

  # GET /occasions/1
  # GET /occasions/1.json
  def show
    @events = @occasion.events
    @guests = Contact.find_by_sql("SELECT contacts.* FROM contacts
       INNER JOIN events ON invitations.event_id = events.id
       INNER JOIN invitations ON contacts.id = invitations.contact_id
       WHERE events.occasion_id = '#{@occasion.id}'
         AND contacts.user_id = #{current_user.id}
       ORDER BY lower(last_name) ASC").uniq
    @response = ResponseType.all
  end

  # GET /occasions/new
  def new
    @occasion = Occasion.new
  end

  # GET /occasions/1/edit
  def edit
  end

  # POST /occasions
  # POST /occasions.json
  def create
    @occasion = current_user.occasions.new(occasion_params)

    respond_to do |format|
      if @occasion.save
        format.html { redirect_to occasion_events_path(@occasion), notice: 'Occasion was successfully created.' }
        format.json { render action: 'show', status: :created, location: @occasion }
      else
        format.html { render action: 'new' }
        format.json { render json: @occasion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /occasions/1
  # PATCH/PUT /occasions/1.json
  def update
    respond_to do |format|
      if @occasion.update(occasion_params)
        format.html { redirect_to occasion_events_path(@occasion), notice: 'Occasion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @occasion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /occasions/1
  # DELETE /occasions/1.json
  def destroy
    @occasion.destroy
    respond_to do |format|
      format.html { redirect_to occasions_url }
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
