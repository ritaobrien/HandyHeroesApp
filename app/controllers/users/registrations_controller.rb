# frozen_string_literal: true


  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  # app/controllers/users/registrations_controller.rb

# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  # Override the create action

  
  def create
   
    super do |resource|
      response.headers["Cache-Control"] = "no-store"
      if resource.persisted?
        # Sign out the user to prevent automatic login after sign up
        sign_out(resource)
        if resource.errors.any?
          # If validation errors occur, we re-render the form with the data entered by the user
          @user.town = params[:user][:town] if params[:user][:town].present?
          @user.county = params[:user][:county] if params[:user][:county].present?
          render :new
        end
        # Check the user role
        if resource.volunteer?
          # Redirect volunteers to the approval pending page
          ApplicationMailer.volunteer_signup_notification(get_admin, resource).deliver_now
          flash[:notice] = "Your account is pending approval. You will be notified by email when your account has been verified. We look forward to having you onboard soon!"
          redirect_to home_volunteer_approval_path and return
        else
          # Redirect other roles to the sign-in page
          flash[:notice] = "Your account was successfully created. Please sign in to continue."
          ApplicationMailer.senior_signup_welcome(resource).deliver_now
          redirect_to new_user_session_path and return
        end
      end
    end

   
  end
  def after_update_path_for(resource)
    tasks_path 
  end
  private

  def user_params
    params.require(:user).permit(:role, :first_name, :last_name, :county, :town, :telephone_number, :photo_id, :id_document)
  end
  
  def get_admin
    User.find_by(role: 'admin')  
  end
end




