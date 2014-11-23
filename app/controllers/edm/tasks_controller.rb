class Edm::TasksController < ApplicationController
  layout nil
  before_action :set_edm_task, only: [:show, :edit, :update, :destroy]

  # GET /edm/tasks
  # GET /edm/tasks.json
  def index
    @edm_tasks = Edm::Task.all
  end

  # GET /edm/tasks/1
  # GET /edm/tasks/1.json
  def show
  end

  # GET /edm/tasks/new
  def new
    @edm_task = Edm::Task.new
  end

  # GET /edm/tasks/1/edit
  def edit
  end

  # POST /edm/tasks
  # POST /edm/tasks.json
  def create
    @edm_task = Edm::Task.new(edm_task_params)

    respond_to do |format|
      if @edm_task.save
        format.html { redirect_to @edm_task, notice: 'Task was successfully created.' }
        format.json { render action: 'show', status: :created, location: @edm_task }
      else
        format.html { render action: 'new' }
        format.json { render json: @edm_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /edm/tasks/1
  # PATCH/PUT /edm/tasks/1.json
  def update
    respond_to do |format|
      if @edm_task.update(edm_task_params)
        format.html { redirect_to @edm_task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @edm_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /edm/tasks/1
  # DELETE /edm/tasks/1.json
  def destroy
    @edm_task.destroy
    respond_to do |format|
      format.html { redirect_to edm_tasks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edm_task
      @edm_task = Edm::Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def edm_task_params
      params.require(:edm_task).permit(:title, :content)
    end
end
