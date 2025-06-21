class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         enum role: { view_only: 0, operator: 1, shift_engineer: 2, chief: 3, admin: 4 }

  has_many :log_entrys
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
end
