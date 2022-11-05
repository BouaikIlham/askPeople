class InboxesController < ApplicationController
  before_action :set_inbox, only: %i[show edit update destroy]
  before_action :authorize_inbox, only: %i[edit update destroy]
  # GET /inboxes or /inboxes.json
  def index
    set_meta_tags title: 'Inboxes'
     @q = Inbox.ransack(params[:q])
     @inboxes = @q.result(distinct: true).order(created_at: :desc)
  end

  # GET /inboxes/1 or /inboxes/1.json
  def show
    set_meta_tags title: @inbox.name
  end

  # GET /inboxes/new
  def new
    set_meta_tags title: 'Add new inbox'
    @inbox = Inbox.new
  end

  # GET /inboxes/1/edit
  def edit; end

  # POST /inboxes or /inboxes.json
  def create
    @inbox = Inbox.new(inbox_params)
    @inbox.user = current_user

    respond_to do |format|
      if @inbox.save
        format.html { redirect_to inbox_url(@inbox), notice: 'Inbox was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inboxes/1 or /inboxes/1.json
  def update
    respond_to do |format|
      if @inbox.update(inbox_params)
        format.html { redirect_to inbox_url(@inbox), notice: 'Inbox was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inboxes/1 or /inboxes/1.json
  def destroy
    @inbox.destroy
    respond_to do |format|
      format.html { redirect_to inboxes_url, notice: 'Inbox was successfully destroyed.' }
    end
  end

  private

  def authorize_inbox
    authorize @inbox
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_inbox
    @inbox = Inbox.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def inbox_params
    params.require(:inbox).permit(:name, :color)
  end
end
