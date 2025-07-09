class LogEntry < ApplicationRecord
  belongs_to :log
  belongs_to :user

  has_rich_text :content # This adds text input functionality like bullets, etc.

    enum entry_type: {
    normal: 0,
    critical: 1,
    info: 2,
    maintenance: 3,
    incident: 4
  }

  validates :entry_type, presence: true
  validates :content, presence: true, on: :create
end
