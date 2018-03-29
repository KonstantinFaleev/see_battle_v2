class Newspost < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }

  validates :title, presence: true
  validates :body, presence: true
end