class Log < ApplicationRecord
  belongs_to :unit
  has_many :log_entries

  validates :date, presence: true
  # validates :status, presence: true
  validates :shift_type, presence: true, inclusion: { in: ['Day Shift', 'Night Shift'], message: "must be either Day Shift or Night Shift" }
  enum status: { open: 0, signed_off: 1, closed: 2, archived: 3 }
  attribute :status, :integer, default: :open
end
