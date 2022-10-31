class Message < ApplicationRecord
  belongs_to :inbox, counter_cache: true
  belongs_to :user
  validates :body, presence: true
  validates :body, uniqueness: { scope: :inbox_id }
  validates :body, length: { in: 6..1000 }

  acts_as_votable
end
