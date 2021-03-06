class Comment < ActiveRecord::Base
  belongs_to :player
  belongs_to :game
  default_scope -> { order('created_at ASC') }

  scope :not_approved, -> { where('approved = ?', false) }

  validates :player_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end