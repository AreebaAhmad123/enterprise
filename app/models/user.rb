class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w[client admin], message: 'must be client or admin' }

  has_many :client_meetings, class_name: 'Meeting', foreign_key: 'client_id'
  has_many :consultant_meetings, class_name: 'Meeting', foreign_key: 'consultant_id'
  has_many :comments

  def client?
    role == 'client'
  end

  def admin?
    role == 'admin'
  end
end