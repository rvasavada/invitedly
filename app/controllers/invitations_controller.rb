class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]

  # GET /invitations
  # GET /invitations.json
  def index
    @occasion = Occasion.friendly.find(params[:occasion_id])
    @events = @occasion.events
    @guests = Contact.find_by_sql("SELECT contacts.* FROM contacts
       INNER JOIN events ON invitations.event_id = events.id
       INNER JOIN invitations ON contacts.id = invitations.contact_id
       WHERE events.occasion_id = '#{@occasion.id}'
         AND contacts.user_id = #{current_user.id}
         AND invitations.is_visible = 't'
       ORDER BY lower(last_name) ASC").uniq
        
    @response = ResponseType.where(:active => true)
  end

  # GET /invitations/1
  # GET /invitations/1.json
  def show
  end

  # GET /invitations/new
  def new
    @occasion = Occasion.friendly.find(params[:occasion_id])
    
    @invitation = Invitation.new
  end

  # GET /invitations/1/edit
  def edit
  end

  # POST /invitations
  # POST /invitations.json
  def create
    @invitation = Invitation.new(invitation_params)

    respond_to do |format|
      if @invitation.save
        format.html { redirect_to @invitation, notice: 'Invitation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @invitation }
      else
        format.html { render action: 'new' }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invitations/1
  # PATCH/PUT /invitations/1.json
  def update
    respond_to do |format|
      if @invitation.update(invitation_params)
        format.html { redirect_to @invitation, notice: 'Invitation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to invitations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:guest_id, :event_id, :num_guests, :message, :response, :is_visible)
    end
end
