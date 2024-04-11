class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: %i[ show edit update destroy ]

  # GET /lists or /lists.json
  def index
    @lists = current_user.lists
  end

  # GET /lists/1 or /lists/1.json
  def show
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
    @tasks = @list.tasks
  end

  # POST /lists or /lists.json
  def create
    @list = List.new(list_params)
    @list.user = current_user

    respond_to do |format|
      if @list.save
        format.html { redirect_to edit_list_url(@list), notice: "List was successfully created." }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1 or /lists/1.json
  def update
    respond_to do |format|
      List.transaction do
        if @list.update(list_params)
          format.html { redirect_to edit_list_path, notice: "List was successfully updated." }
          format.json { render :edit, status: :ok, location: @list }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @list.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /lists/1 or /lists/1.json
  def destroy
    @list.destroy!

    respond_to do |format|
      format.html { redirect_to lists_url, notice: "List was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = current_user.lists.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def list_params
      params.require(:list).permit(:name, tasks_attributes: [:id, :description, :is_complete])
    end
end
