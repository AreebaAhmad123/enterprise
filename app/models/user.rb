class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable
  has_many :client_meetings, class_name: 'Meeting', foreign_key: 'client_id', dependent: :destroy
  has_many :consultant_meetings, class_name: 'Meeting', foreign_key: 'consultant_id', dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w[user client admin], message: 'must be user, client or admin' }
  before_save :set_consultant_role_for_admin
  scope :available_consultants, -> { where(consultant_role: true).order(:full_name) }
  def user?
    role == 'user'
  end
  def client?
    role == 'client'
  end
  def admin?
    role == 'admin'
  end
  def can_act_as_consultant?
    consultant_role || admin?
  end
  def acting_as_admin?
    acting_as_admin || admin?
  end
  def acting_role
    admin? ? (session[:acting_role] || 'admin') : role
  end
  def confirmation_required?
    false
  end
  def full_name
    "#{first_name} #{last_name}"
  end
  private
  def set_consultant_role_for_admin
    self.consultant_role = true if admin?
  end
end