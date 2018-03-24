class Comment < ActiveRecord::Base
  belongs_to :player
  belongs_to :game
  default_scope -> { order('created_at DESC') }

  validates :player_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end