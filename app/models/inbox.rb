class Inbox < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { in: 6..100 }

  belongs_to :user
  has_many :messages
end
