class ApplicationMailer < ActionMailer::Base
  default from: "rita.t.obrien@gmail.com"
  layout "mailer"
  
  def admin_volunteer_approval_notification(volunteer)
    @volunteer = volunteer
    mail(to: @volunteer.email, subject: 'Your Volunteer Application Has Been Approved!')
  end

  def admin_volunteer_approval_pending(volunteer)
    @volunteer = volunteer
    mail(to: @volunteer.email, subject: 'Your Volunteer Application Has Been Received and will be verified.')
  end

  def senior_signup_welcome(senior)
    @senior = senior
    mail(to: @senior.email, subject: 'Your Senior Account has been created!')
  end

  def volunteer_signup_notification(admin, volunteer)
    @volunteer = volunteer
    

    admins = User.where(role: 'admin')  # Assuming you have a User model and a role attribute
    mail(to: admins.pluck(:email), subject: 'New Volunteer Awaiting Approval')

  end
  
  def senior_task_accepted(task)
    @task = task
    @senior = @task.senior
    @volunteer = task.volunteer
    

    if @volunteer.photo_id.attached?
      attachments.inline['volunteer_photo.jpg'] = @volunteer.photo_id.download
    end

    mail(to: @senior.email, subject: "Your Task Has Been Accepted by #{@volunteer.first_name} #{@volunteer.last_name}!")
  end
  
  def volunteer_task_accepted(task)
    @task = task
    @senior = @task.senior
    @volunteer = task.volunteer

    mail(to: @volunteer.email, subject: "Thank you for accpeting a task for #{@senior.first_name} #{@senior.last_name}! ")
  end
  


  def senior_task_completed(task, rate_task_url)
    @task = task
    @rate_task_url = rate_task_url
    @senior = @task.senior
    @volunteer = task.volunteer
    
   

    mail(to: @senior.email, subject: "Your task #{@task.task_type} has been completed.")
  end

  def volunteer_task_completed(task)
    @task = task
    @senior = @task.senior
    @volunteer = task.volunteer

   

    mail(to: @volunteer.email, subject: "Thank you for completing a tssk!")
  end

 

  def volunteer_task_rated(task)
    @task = task
    @senior = @task.senior
    @volunteer = task.volunteer
    mail(to: @volunteer.email, subject: "Your completed task has been rated!")
  end


  
  def senior_task_released(task)
    @task = task
    @senior = task.senior
  
    mail(
      to: @senior.email,
      subject: "Your Task has Returned to Pending Status",
      
    )
  end
  


  def pending_task_deleted(task)
    @task = task
    @senior = @task.senior
    mail(to: @senior.email, subject: "Your Pending Task Has Been Deleted. ")
  end

  def senior_task_created(task)
    @task = task
    @senior = @task.senior
    mail(to: @senior.email, subject: "Your New Task Has Been Created. ")
  end

  


  def volunteer_task_created(task, volunteer)
    @task = task
    @volunteer = volunteer
    mail(to: @volunteer.email, subject: "A New Task Is Acailable In Your Area.")
  end
  
  

  def accepted_task_deleted_senior(task)
    @task = task
    @senior = @task.senior
    @volunteer = task.volunteer
    mail(to: @senior.email, subject: "Your Task Has Been Deleted. Your Handy Hero #{@volunteer.first_name} #{@volunteer.last_name} has been notified.")
  end

  def accepted_task_deleted_volunteer(task)
    @task = task
    @senior = @task.senior
    @volunteer = task.volunteer
    mail(to: @volunteer.email, subject: "A task that you have sccepted for #{@senior.first_name} #{@senior.last_name} has been deleted by them.")
  end

  def task_released(task)
    @task = task
    @senior = task.senior
    mail(to: @senior.email, subject: 'Task Released Notification')
  end

  def volunteer_task_reset_notification(senior, task)
    @senior = senior
    @task = task

    mail(
      to: task.volunteer.email, # Email of the volunteer to notify
      subject: 'Task Reset Notification'
    )
  end

  def volunteer_task_deletion_notification(volunteer, task)
    @task = task
    @volunteer = volunteer

    mail(
      to: volunteer.email,
      subject: 'Task Deletion Notification'
    )
  end

  def new_task_notification(volunteer, tasks)
    @volunteer = volunteer
    @tasks = tasks
    mail(to: @volunteer.email, subject: 'New Tasks Posted in Your Area')
  end

end


