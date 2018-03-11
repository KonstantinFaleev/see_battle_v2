class Ship < ActiveRecord::Base
  belongs_to :game, :foreign_key => 'game_id', :class_name => 'Game'

  def is_sunk?
    if self.decks == 0
      true
    else
      false
    end
  end
end
