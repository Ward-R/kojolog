class Log < ApplicationRecord
  belongs_to :unit
  has_many :log_entrys

  validates :date, presence: true
  validates :status, presence: true
  validates :shift_type, presence: true
end
