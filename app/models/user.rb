class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         enum role: { standard: 0, admin: 1, manager: 2 }

  has_many :log_entrys
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
end
