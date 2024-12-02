class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :tasks, foreign_key: :senior_id

  has_one_attached :photo_id
  has_one_attached :id_document

  enum role: { volunteer: 0, senior: 1, admin: 2 }
  
  validates :first_name, :last_name, :email, :county, :town, :telephone_number, presence: true
  
  after_initialize :set_default_approval, if: :new_record?

  validates :approved, inclusion: { in: [true, false] }
  
  validates :photo_id, :id_document, presence: true, if: :volunteer?


  def active_for_authentication?
    super && (approved? || role != 'volunteer')
  end




  # Provide a custom message when user is inactive
  def inactive_message
    !approved? && role == 'volunteer' ? :not_approved : super
  end







  def inactive_message
    if volunteer? && !approved?
      :unapproved_account # This will use the translation key
    else
      super
    end
  end
  private

  def set_default_approval
    self.approved = role != "volunteer"
  end
end
