class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :role, inclusion: { in: %w[client admin], message: "must be client or admin" }
  has_many :client_meetings, class_name: "Meeting", foreign_key: "client_id"
  has_many :consultant_meetings, class_name: "Meeting", foreign_key: "consultant_id"

  def client?
    role == "client"
  end

  def admin?
    role == "admin"
  end
end