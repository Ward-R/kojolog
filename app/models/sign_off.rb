class SignOff < ApplicationRecord
  belongs_to :log
  belongs_to :user
end
