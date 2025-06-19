class Unit < ApplicationRecord
  has_many :logs
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
