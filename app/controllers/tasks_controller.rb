class TasksController < ApplicationController
  
  before_action :set_task, only: %i[show destroy release accept rate]
  before_action :authenticate_user!
  #before_action :ensure_senior_user, only: %i[new create edit update destroy]
  #before_action :ensure_volunteer_user, only: %i[index accept]

  # GET /tasks or /tasks.json

    def index
      if current_user.senior?
        @tasks = current_user.tasks 
      elsif current_user.volunteer?
        @tasks = Task.joins(:senior).where(volunteer_id: nil, users: { town: current_user.town }) 
      else
        @tasks = [] 
      end
    end

    def admin_dashboard
      @pending_volunteers = Volunteer.where(approved: false)
      @users = User.all
      @tasks = Task.all # Assuming you have a Task model
      @pending_tasks = Task.where(status: 'pending') 
      @accepted_tasks = Task.where(status: 'accepted') 
      @completed_tasks = Task.where(status: 'completed') 
    end
    

    def pending
      # Show tasks that have not been accepted yet
      @tasks = Task.where(volunteer_id: nil)
    end
  
    # GET /tasks/my_tasks
    def my_tasks
      # Show tasks accepted by the current user
      @tasks = Task.where(volunteer_id: current_user.id)
    end
  
   
    
  

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end



  def available_tasks
    # Get tasks in the volunteer's town only if they are in the role of a volunteer
    if current_user.volunteer?
      @tasks = Task.where(town: current_user.town, status: 'pending')
    else
      @tasks = Task.none
      flash[:alert] = "Only volunteers can view available tasks."
      redirect_to root_path
    end
  end

  def create
    @task = current_user.tasks.build(task_params) # Automatically sets senior_id to current_user.id
    if @task.save
      ApplicationMailer.senior_task_created(@task).deliver_now
      volunteers_in_town = User.where(town: @task.senior.town, role: 'volunteer') # Assuming 'volunteer' role

      # Send email to each volunteer in the same town
      volunteers_in_town.each do |volunteer|
        ApplicationMailer.volunteer_task_created(@task, volunteer).deliver_now
      end
      redirect_to tasks_path, notice: "Task created successfully."
    else
      render :new
    end
  end

  

  def accept_task
    @task = Task.find(params[:id])
    @volunteer = current_user # Assuming current_user is the volunteer accepting the task
    @task.update(volunteer: @volunteer, status: 'accepted')
    @senior = @task.senior 
    
    ApplicationMailer.senior_task_accepted(senior, @volunteer).deliver_now
    ApplicationMailer.volunteer_task_accepted(senior, @volunteer).deliver_now
    

    flash[:notice] = "Task accepted successfully, and senior has been notified."
    redirect_to tasks_path
  end



    def mark_complete
      @task = Task.find_by(id: params[:id]) # Use find_by to avoid raising an error
    
      if @task.nil?
        flash[:alert] = "Task not found."
        redirect_to my_tasks_path and return
      end
    
      if @task.update(status: 'completed') # Update the status as needed
        flash[:notice] = "Task marked as complete."
      else
        flash[:alert] = "Failed to mark task as complete."
      end
      redirect_to my_tasks_path
    end
    
 




  def accept
    @senior = @task.senior 
    if current_user.volunteer? && @task.update(volunteer_id: current_user.id, status: 'accepted')
      redirect_to my_tasks_path, notice: 'Task successfully accepted.'
      ApplicationMailer.senior_task_accepted(@task).deliver_now
ApplicationMailer.volunteer_task_accepted(@task).deliver_now
    else
      redirect_to tasks_path, alert: 'Failed to accept task or unauthorized action.'
    end
  end
  


  def destroy
    if @task.status == 'pending'
      ApplicationMailer.pending_task_deleted(@task).deliver_now
    end
    if @task.status == 'accepted'
     
      if current_user.role=='senior'
        ApplicationMailer.accepted_task_deleted_senior(@task).deliver_now
        ApplicationMailer.accepted_task_deleted_volunteer(@task).deliver_now
      else
        redirect_to tasks_path, alert: 'Failed to delete task or unauthorized action.'
      end
      @task.destroy

      # Set a flash message to inform the senior
      flash[:success] = "Task was successfully deleted, and the volunteer has been notified."
    else
      # For pending tasks, just delete
      @task.destroy
      flash[:success] = "Task was successfully deleted."
    end

    # Redirect the senior back to their tasks page

    if current_user.admin?
      # Admin's redirect logic (with section anchors for pending, accepted, or completed tasks)
     
        redirect_to home_admin_dashboard_path(anchor: 'pending-tasks'),status: :see_other
  
    else
      if current_user.volunteer?
      redirect_to my_tasks_path, status: :see_other
    else 
      redirect_to tasks_path, status: :see_other
    end
  end
end





  def release
   
    if @task.volunteer != current_user
      flash[:alert] = "You are not authorized to release this task."
      redirect_to tasks_path and return
    end

  
    if @task.update(status: 'pending', volunteer: nil)
      ApplicationMailer.senior_task_released(@task).deliver_now

      volunteers_in_town = User.where(town: @task.senior.town, role: 'volunteer')

    # Send email to each volunteer in the same town
    volunteers_in_town.each do |volunteer|
      ApplicationMailer.volunteer_task_created(@task, volunteer).deliver_now
    end

      flash[:notice] = "Task has been released successfully."
    else
      flash[:alert] = "Failed to release the task. Please try again."
    end

    redirect_to my_tasks_path
  end


  def complete_with_comment
    @task = Task.find(params[:id])
    
    # Ensure a comment is provided
    if params[:comment].blank?
      flash[:alert] = "Please enter a comment before completing the task."
      redirect_to my_tasks_path and return
    end
  
    # Update the task with the comment and mark it as completed
    if @task.update(comment: params[:comment], status: 'completed')
      flash[:notice] = "Task marked as complete with your comment."
      rate_url = url_for(controller: 'tasks', action: 'rate', id: @task.id, host: request.host, port: request.port)
      ApplicationMailer.senior_task_completed(@task, rate_url).deliver_now
      ApplicationMailer.volunteer_task_completed(@task).deliver_now
        redirect_to my_tasks_path, notice: 'Task completed successfully!'
      
    else
      flash[:alert] = "Failed to complete the task. Please try again."
      redirect_to my_tasks_path
    end
  end
  
  def rate
    @task = Task.find(params[:id])
    
    # Handle case where task is not found
    if @task.nil?
      flash[:alert] = "Task not found."
      redirect_to tasks_path and return
    end
  
    # Ensure rating is valid (1-5 stars)
    rating = params[:task][:rating].to_i
    
    if (1..5).include?(rating)
      if @task.update(rating: rating)
        flash[:notice] = "Thank you for rating your Handy Hero!"
        
        ApplicationMailer.volunteer_task_rated(@task).deliver_now
      else
        flash[:alert] = "There was an error updating the rating. Please try again."
      end
    else
      flash[:alert] = "Invalid rating. Please select a value between 1 and 5."
    end
  
    redirect_to tasks_path
  end
  

  
  
  
  private

  def set_task
    @task = Task.find_by(id: params[:id]) # Using find_by to avoid exception if task is not found
  end


  
  

  helper TasksHelper

 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to tasks_path, alert: 'Task not found.'
    end


    # Only allow a list of trusted parameters through.
  

    def task_params
      params.require(:task).permit(:task_category, :task_type, :description, :status, :comment)
    end
    
end
