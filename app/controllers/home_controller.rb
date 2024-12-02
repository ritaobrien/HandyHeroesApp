class HomeController < ApplicationController
  
  skip_before_action :authenticate_user!, only: [:index, :howitworks, :volunteer_approval]
  
  def index
  end

  def volunteer_dashboard
  end

  def senior_dashboard
  end

  def available_tasks
  end
  
  def how_it_works
  end

  def admin_dashboard
    # Retrieve all users and filter pending volunteers
    @users = User.all
    @pending_volunteers = User.where(role: 'volunteer', approved: false)
    @tasks = Task.all # or Task.where(...) if you want specific filters
    @accepted_tasks_count = Task.where(status: 'accepted').count
    
    @users = User.all
    @tasks = Task.all # Assuming you have a Task model
    @pending_tasks = Task.where(status: 'pending') 
@accepted_tasks = Task.where(status: 'accepted') 
@completed_tasks = Task.where(status: 'completed') 
  end

  def volunteer_approval
  end

  







    #before_action :authenticate_user!, only{:}
    before_action :require_admin, only: [:admin_dashboard, :approve_volunteer, :destroy_volunteer]
  
   
    # Approve a volunteer
    def approve_volunteer
      @volunteer = User.find(params[:id])  # Find the volunteer by ID
  
      if @volunteer.update(approved: true)
        flash[:notice] = 'Volunteer was successfully approved.'
        ApplicationMailer.admin_volunteer_approval_notification(@volunteer).deliver_now # Send email notification
      else
        flash[:alert] = 'There was a problem approving the volunteer @volunteer.'
      end
  
      redirect_to home_admin_dashboard_path  # Redirect back to the admin dashboard
    end
  
    def destroy_volunteer
      @user = User.find(params[:id])
      
      if @user.senior? 
        handle_senior_deletion(@user)
      elsif @user.volunteer? 
        handle_volunteer_deletion(@user)
      end


      if @user.destroy
        
        flash[:notice] = 'User was successfully deleted.'
      else
        flash[:alert] = 'There was a problem deleting the volunteer.'
      end
      
      redirect_to home_admin_dashboard_path  # Redirect to the appropriate page
    end

    def notify_volunteer_about_task_reset(volunteer, task)
      return unless volunteer
    
      # Example email notification (replace with your mailer logic)
      ApplicationMailerMailer.senior_task_reset_notification(volunteer, task).deliver_now
    end
    
    def notify_senior_about_task_reset(senior, task)
      return unless senior
    
      # Example email notification (replace with your mailer logic)
      ApplicationMailer.volunteer_task_reset_notification(senior, task).deliver_now
    end

    def submit_documents
      @user = current_user  # Set @user to the currently logged-in user
  
     
  
      # Update only if user is a volunteer
      if @user.role == 'volunteer' && @user.update(user_params)
        flash[:notice] = "Your documents have been submitted. You will be notified by email when they have been verified."
        redirect_to root_path
      else
        flash[:alert] = "There was an error submitting your documents. Please try again."
        render :volunteer_approval
      end
    end
    
    


   
    
    private
    def handle_senior_deletion(senior)
      # Notify volunteers about task deletion (if applicable)
      accepted_tasks = Task.where(senior_id: senior, status: 'accepted')
      accepted_tasks.each do |task|
        ApplicationMailer.volunteer_task_deletion_notification(task.volunteer, task).deliver_now
      end
    
      # Delete all tasks associated with the senior
      Task.where(senior_id: senior).destroy_all
    end


    def handle_volunteer_deletion(volunteer)
      # Find tasks accepted by this volunteer
      accepted_tasks = Task.where(volunteer_id: volunteer, status: 'accepted')
    
      # Notify seniors about task status changes
      accepted_tasks.each do |task|
        ApplicationMailer.volunteer_task_reset_notification(task.senior, task).deliver_now
      end
    
      # Reset accepted tasks to pending
      accepted_tasks.update_all(status: 'pending', volunteer_id: nil)
    
      # No need to handle pending tasks here since they are not associated with volunteers
    end


    # Ensure only admins can access admin-specific actions
    def require_admin
      redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
    end
    def user_params
      params.require(:user).permit(:photo_id, :id_document) # Only permit if user is a volunteer
    end

  
end
