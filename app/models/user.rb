class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :client_meetings, class_name: 'Meeting', foreign_key: 'client_id', dependent: :destroy
  has_many :consultant_meetings, class_name: 'Meeting', foreign_key: 'consultant_id', dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :consultant_role, inclusion: { in: [true, false] }, allow_nil: false
  scope :available_consultants, -> { where(consultant_role: true).order(:full_name) }

  def client?
    consultant_role == false
  end

  def consultant?
    consultant_role == true
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  before_save :set_role

  private

  def set_role
    self.role = consultant_role ? 'consultant' : 'client'
  end
end