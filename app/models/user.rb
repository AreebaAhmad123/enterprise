class User < ApplicationRecord
  has_many :sessions, foreign_key: 'user_id'
  has_many :consulting_sessions, class_name: 'Session', foreign_key: 'consultant_id'
  has_many :comments
  has_many :payments

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :auth0_id, uniqueness: true, allow_nil: true
  validates :role, presence: true, inclusion: { in: %w[client consultant admin] }

  def client?
    role == 'client'
  end

  def consultant?
    role == 'consultant'
  end

  def admin?
    role == 'admin'
  end

  def self.consultants
    where(role: 'consultant')
  end
end