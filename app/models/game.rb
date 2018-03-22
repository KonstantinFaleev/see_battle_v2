class Game < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }

  serialize(:player_a_board, Array)
  serialize(:player_b_board, Array)
  serialize(:ai_moves_pull, Array)
  serialize(:ai_neglected_moves, Array)

  validates :player_a_id, presence: true
  validates :player_b_id, presence: true
  validates :player_a_ships, presence: true
  validates :player_b_ships, presence: true

  belongs_to :player_a, :foreign_key => 'player_a_id', :class_name => 'Player'
  belongs_to :player_b, :foreign_key => 'player_b_id', :class_name => 'Player'
  belongs_to :looser, :foreign_key => 'looser_id', :class_name => 'Player'
  belongs_to :winner, :foreign_key => 'winner_id', :class_name => 'Player'
  has_many :ships,:foreign_key => 'game_id', :class_name => 'Ship'

  #to differ cases when ship is hit and player should move again
  attr_accessor :move_again

  # Returns a new Game object with the associated players A and Bot
  def self.start_game(player_a, player_b, board)
    g = Game.new(player_a: player_a, player_b: player_b)

    g.title = "#{player_a.name} vs. #{player_b.name}"

    if board.nil? || !Board.find_by_id(board).is_ready?
      g.player_a_board = new_random_board
    else
      g.player_a_board = Board.find_by_id(board).grid
    end

    g.player_b_board = new_random_board
    g.move_again = false
    g.ai_neglected_moves = []
    g.ai_moves_pull = []

    g.save

    Board.where("player_id = ? AND saved = ?", player_a.id, false).delete_all

    return g
  end

  #each cell of the board is array of two elements.
  #the first element shows cell content
  #the second one is 0 if cell is empty, or contains a link to a ship object
  #cell content:
  #0 - not checked cell, empty
  #1 - not checked cell, contains deck of a ship
  #3 - damaged or sunk ship
  #4 - checked empty cell
  def self.new_random_board
    board = Board.new

    while !board.is_ready?
      board.direction = rand(2) == 1 ? true : false
      board.place_ship(rand(10), rand(10))
    end

    return board.grid
  end

  def game_over?
    return true if player_a_ships == 0
    return true if player_b_ships == 0

    return false
  end

  # The do move method is intended to process player moves
  def do_move(player, x, y)
    flag = self.player_a == player

    board = flag ? self.player_b_board : self.player_a_board
    ships = flag ? self.player_b_ships : self.player_a_ships
    other_player = flag ? self.player_b : self.player_a

    if board[x][y][0] == 1
      board[x][y][0] = 3
      ship = board[x][y][1].reload
      ship.update_attribute('decks', ship.decks-1)
      ships -= 1
      self.move_again = true
      self.game_log = "#{player.name} shoots #{('A'..'J').to_a[y]}#{x} and " \
                      "damages #{other_player.name}'s ship!\n" + self.game_log
      if ship.reload.is_sunk?
        player.increment!(:ships_destroyed, by = 1)
        other_player.increment!(:ships_lost, by = 1)
        self.game_log = "#{other_player.name}'s ship is now destroyed!\n" + self.game_log
      end

      #AI next move coordinates determination
      if !flag
        set_ai_next_move x, y
      end

    elsif board[x][y][0] == 0
      board[x][y][0] = 4
      self.move_again = false
      self.game_log = "#{player.name} shoots #{('A'..'J').to_a[y]}#{x} and misses.\n" + self.game_log
    end

    if flag
      self.player_b_board = board
      self.player_b_ships = ships
    else
      self.player_a_board = board
      self.player_a_ships = ships
      self.ai_neglected_moves << [x,y]
    end

    set_play_status player, false
  end

  # Method that sets the play_status member
  def set_play_status(player, surrender)
    if game_over?
      # forced to use update_attributes explicitly?
      #self.winner = player
      self.update_attributes :winner => player
      if self.winner == self.player_a
        self.update_attributes :looser => player_b
        self.play_status = "You have won this game. Congratulations!"
      else
        self.update_attributes :looser => player_a
        if surrender
          self.play_status = "You have surrendered."
        else
          self.play_status = "You've lost to #{self.player_b.name}. Better luck next time!"
        end
      end

      self.game_log = "#{player.name} receives 100 pts.\n#{looser.name} loses 50 pts.\n" + self.game_log

      if surrender
        self.game_log = "Game is over. #{self.looser.name} has surrendered.\n" + self.game_log
      else
        self.game_log = "Game is over. #{player.name} celebrates the victory.\n" + self.game_log
      end

      self.looser.update_attribute('rating', self.looser.rating - 50)
      player.update_attribute('rating', player.rating + 100)

      self.ai_moves_pull = self.ai_neglected_moves = nil
    end
    self.save
  end

  def surrender_game
    self.player_a_ships = 0
    set_play_status player_b, true
  end

  def get_move_for_ai

    if self.ai_moves_pull.empty?
      x = rand(10)
      y = rand(10)

      while self.ai_neglected_moves.include?([x,y])
        x = rand(10)
        y = rand(10)
      end

      return x,y
    else
      ind = rand(self.ai_moves_pull.size)
      x,y = self.ai_moves_pull[ind]
      self.ai_moves_pull.delete_at(ind)

      return x,y
    end
  end

  def set_ai_next_move(x,y)

    if self.player_a_board[x][y][1].reload.is_sunk?
      for i in x-1..x+1
        for j in y-1..y+1
          self.ai_neglected_moves << [i, j]
        end
      end
      self.ai_moves_pull = []
    else
      self.ai_neglected_moves << [x+1, y+1]
      self.ai_neglected_moves << [x-1, y-1]
      self.ai_neglected_moves << [x+1, y-1]
      self.ai_neglected_moves << [x-1, y+1]
      if  self.ai_moves_pull.empty?
        self.ai_moves_pull << [x-1, y] unless x-1 < 0 || self.ai_neglected_moves.include?([x-1, y])
        self.ai_moves_pull << [x+1, y] unless x+1 > 9 || self.ai_neglected_moves.include?([x+1, y])
        self.ai_moves_pull << [x, y-1] unless y-1 < 0 || self.ai_neglected_moves.include?([x, y-1])
        self.ai_moves_pull << [x, y+1] unless y+1 > 9 || self.ai_neglected_moves.include?([x, y+1])
      else
        x1 = y1 = x2 = y2 = 0
        self.ai_moves_pull.each do |e|
          if e[0] == x
            x1,y1 = e
            if e[1] < y
              x2,y2 = x,y+1 unless y+1 > 9
            else
              x2,y2 = x,y-1 unless y-1 < 0
            end
          elsif e[1] == y
            x1,y1 = e
            if e[0] < x
              x2,y2 = x+1,y unless x+1 > 9
            else
              x2,y2 = x-1,y unless x-1 < 0
            end
          end
        end
        self.ai_moves_pull.each do |e|
          if e != [x1,y1]
            self.ai_neglected_moves << e
          end
        end
        self.ai_moves_pull = []
        self.ai_moves_pull << [x1,y1] unless [x1,y1] == [0,0]
        self.ai_moves_pull << [x2,y2] unless [x2,y2] == [0,0]
      end
    end
  end

end