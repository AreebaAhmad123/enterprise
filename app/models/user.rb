# class User < ApplicationRecord
#   # Include default devise modules. Others available are:
#   # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
#   devise :database_authenticatable, :registerable,
#          :recoverable, :rememberable, :validatable
# end
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sessions, foreign_key: 'user_id'
  has_many :consulting_sessions, class_name: 'Session', foreign_key: 'consultant_id'
  has_many :comments
  has_many :payments

  validates :name, presence: true
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