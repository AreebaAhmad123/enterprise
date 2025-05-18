class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :role, inclusion: { in: %w[client admin], message: "must be client or admin" }

  def client?
    role == "client"
  end

  def admin?
    role == "admin"
  end
end