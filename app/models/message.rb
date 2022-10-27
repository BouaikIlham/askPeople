class Message < ApplicationRecord
  belongs_to :inbox
  belongs_to :user

  validates :body, presence: true
  validates :body, uniqueness: true
  validates :body, length: { in: 6..1000 }
end
