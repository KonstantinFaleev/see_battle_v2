class Game < ActiveRecord::Base

  attr_accessor :safe_gaurd_count

  validates :player_a_id, presence: true
  validates :player_b_id, presence: true

  belongs_to :player_a, :foreign_key => 'player_a_id', :class_name => 'Player'
  belongs_to :player_b, :foreign_key => 'player_b_id', :class_name => 'Player'
  belongs_to :winner, :foreign_key => 'winner_id', :class_name => 'Player'
  has_many :moves

  attr_reader :play_status

  # Returns a new Game object with the associated players A and Bot
  def self.start_game(player_a, player_b)
    g = Game.new
    g.player_a = player_a
    g.player_b = player_b
    g.player_a_ships = 20
    g.player_b_ships = 20
    g.player_a_board = Board.new
    #Board object has not been designed yet.
    #Should return a new board 10x10 with randomly placed ships
    g.player_b_board = Board.new

    g.save

    return g
  end

  def game_over?
    return true if player_a_ships == 0
    return true if player_b_ships == 0

    return false
  end

  def win_found(criteria)
    curr_player = self.moves[-1].player
    moves = Move.where("game_id = ?", self.id)
                .where("player_id = ?", curr_player.id)
                .where(criteria)

    (moves.length == 3)
  end

  # This method performs the following checks and returns false if they exist
  # 1. has the game already been over
  # 2. is it the players turn yet
  def does_context_allow_move(player)
    # check 1: is the game already over?
    if !winner.nil?
      self.errors.add('move not allowed, game is already over.', '')
      return false
    elsif !self.moves.empty? && self.find_last_move.player == player
      # check 2: is players turn?
      self.errors.add('move cannot be played, it is not your turn.', '')
      return false
    else
      return true
    end
  end

  # The do move method creates a new move based on the method parameters
  # but before adding it to the game it verifies that the move is legal
  # If the move was valid then sets the play_status property so the UI knows what to do
  def do_move(player, x, y)

    if !does_context_allow_move(player) then return end

    move = Move.new(:title => "Move (#{x}, #{y})")
    move.player = player
    move.x_axis = x
    move.y_axis = y

    # check if move alreay played
    if move.move_available?(self) then
      self.moves << move
      if player_b_board(getCell(x, y)) == 1
        #ship is hit, do smth here
      else
        #miss, do smth here
      end
    else
      self.errors.add('move has already been taken', '')
      return
    end

    set_play_status player
  end

  # Method that sets the play_status member
  def set_play_status(player)
    if game_over?
      # setting the member and then later save issues NULL?
      # forced to use update_attributes explicitly?
      #self.winner = player
      self.update_attributes :winner => player

      if self.winner == self.player_x then
        #@play_status = StatusType::PLAYER_WON
      else
        #@play_status = StatusType::BOT_WON
      end
    end
  end

  # Method that creates and returns bot moves
  # Uses random numbers to determine what move to try
  # verifies that the move is available before returning
  # if the move is not available then it calls it self recursively until found
  def create_move
    #get available cells on the player_a_board
    #make random shot
    #do smth if ship is hit
    #else
    #do smth if miss
  end

  protected

  def find_last_move
    return Move.find(:first, :conditions => ['game_id = ?', self], :order => "id DESC")
  end
end
