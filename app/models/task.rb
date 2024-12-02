class Task < ApplicationRecord
    belongs_to :senior, class_name: "User", foreign_key: "senior_id", optional: true
    belongs_to :volunteer, class_name: "User", foreign_key: "volunteer_id", optional: true

    validates :senior_id, presence: true
    validates :task_category, :task_type, presence: true
    validates :comment, length: { maximum: 500 }, allow_blank: true
    belongs_to :senior, class_name: 'User'
    belongs_to :volunteer, class_name: 'User', optional: true
  
    enum status: {
        pending: 'Pending',
        accepted: 'Accepted',
        completed: 'Completed'
      }
    
      # Set default status to Pending when a new task is created
      before_validation :set_default_status, on: :create
    
      private
    
      def set_default_status
        self.status ||= 'Pending'
      end




end
