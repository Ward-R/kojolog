class Log < ApplicationRecord
  belongs_to :unit
  has_many :log_entries

  validates :date, presence: true
  validates :status, presence: true
  validates :shift_type, presence: true
end
