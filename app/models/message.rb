class Message < ApplicationRecord
  belongs_to :inbox, counter_cache: true
  belongs_to :user
  validates :body, presence: true
  validates :body, uniqueness: { scope: :inbox_id }
  validates :body, length: { in: 6..1000 }

  acts_as_votable

  enum status: {
    incoming: 'incoming',
    todo: 'todo',
    done: 'done',
    spam: 'spam'
  }

  def upvote!(user)
    if user.voted_up_on? self, vote_scope: 'like'
      unvote_by user, vote_scope: 'like'
    else
      upvote_by user, vote_scope: 'like'
    end
  end
end
