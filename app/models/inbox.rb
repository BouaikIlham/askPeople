class Inbox < ApplicationRecord
    validates :name, presence: true
    validates :name, uniqueness: true
      validates :name, length: { in: 6..20 }

end