class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :check_volunteer_approval, if: :user_signed_in?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :first_name, :last_name, :county, :town, :telephone_number, :photo_id, :id_document])
    devise_parameter_sanitizer.permit(:account_update, keys: [:role, :first_name, :last_name, :county, :town, :approved]) if current_user&.admin?
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :email])
  end

  def after_sign_up_path_for(resource)
    if resource.role == "volunteer"
      home_volunteer_approval_path 
    elsif resource.role == "senior"
      home_volunteer_dashboard_path
    else
      user_root_path
    end
  end



  def after_sign_in_path_for(resource)
    if resource.role == "volunteer"
      tasks_path 
    elsif resource.role == "senior"
      tasks_path
    elsif resource.role == "admin"
      home_admin_dashboard_path
    else
      user_root_path
    end
  end

  private
  
  def check_volunteer_approval
    # If the current user is a volunteer and not approved, redirect them
    if current_user.volunteer? && !current_user.approved?
      redirect_to waiting_for_approval_path, alert: "Your account is awaiting approval. You will be notified once approved."
    end
  end
  
end



