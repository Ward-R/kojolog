class LogEntry < ApplicationRecord
  belongs_to :log
  belongs_to :user

  validates :entry_type, presence: true
  validates :content, presence: true
end
