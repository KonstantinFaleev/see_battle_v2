class Move < ActiveRecord::Base

  belongs_to :game
  belongs_to :player

  validates_presence_of :player
  validates_presence_of :game
  validate :move_is_ok


  # Returns true if this move does not exist for the given game yet
  # === Parameters
  # * game = the game that wants to add this move to itself
  # === Example
  def move_available?(game)
    return Move.where(:conditions => ["game_id = ? and player_id = ? and x_axis = ? and y_axis = ?", game, self.player_id, self.x_axis, self.y_axis]).all.empty?
  end

  # ******************************
  # ******************************
  protected

  def move_is_ok
    errors.add("Moves", " is not valid, it has already been taken.") unless move_ok?
  end

  def move_ok?
    items = Move.where(:conditions => ["game_id = ? and player_id = ? and x_axis = ? and y_axis = ?", self.game, self.player_id, self.x_axis, self.y_axis]).all

    return true if items.empty? or (items[0] == self) else return false
  end
end
