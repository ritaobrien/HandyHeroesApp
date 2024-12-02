module ApplicationHelper
    def dashboard_path_for(user)
        case user.role
        when 'volunteer'
          home_volunteer_dashboard_path
        when 'senior'
          home_senior_dashboard_path
        when 'admin'
          home_admin_dashboard_path
        else
          root_path # Default path if no role matches
        end
    end
    
    
    def user_not_signed_up?
      !user_signed_in? && flash[:signed_up].nil?
    end

    def user_signed_up_not_approved?
      !user_signed_in? && flash[:signed_up].nil?
    end

    def signed_up_but_not_approved?
      user_signed_in? && !current_user.approved?
    end


 
      def task_status_class(status)
        case status
        when 'pending'
          'cardorange'
        when 'accepted'
          'cardblue'
        when 'completed'
          'cardgold'
        else
          'carddefault'
        end
      end
    
      def card_header_class(status)
        case status
        when 'pending'
          'card-header-pending'
        when 'accepted'
          'card-header-accepted'
        when 'completed'
          'card=header-completed'
        else
          'bg-secondary'
        end
      end

    


end
