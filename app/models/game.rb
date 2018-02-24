class Game < ActiveRecord::Base
  serialize(:player_a_board, Array)
  serialize(:player_b_board, Array)
  attr_accessor :safe_gaurd_count

  validates :player_a_id, presence: true
  validates :player_b_id, presence: true
  validates :player_a_ships, presence: true
  validates :player_b_ships, presence: true

  belongs_to :player_a, :foreign_key => 'player_a_id', :class_name => 'Player'
  belongs_to :player_b, :foreign_key => 'player_b_id', :class_name => 'Player'
  belongs_to :winner, :foreign_key => 'winner_id', :class_name => 'Player'

  # Returns a new Game object with the associated players A and Bot
  def self.start_game(player_a, player_b)
    g = Game.new
    g.player_a = player_a
    g.player_b = player_b
    g.player_a_board = new_board
    g.player_b_board = new_board
    g.game_log = "Game has started."

    g.save

    return g
  end

  def self.new_board
    grid = []
    10.times do
      grid << [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    end
    ships = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1]
    #set Battleship
    ships.each do |ship|
      grid = place_ship(grid, ship)
    end
    return grid
  end

  def self.place_ship(grid, ship)
    dir = rand(2) #1 for horizontal, 0 for vertical

    if dir == 0
      x = rand(10-ship) + ship
      y = rand(10)
    else
      y = rand(10-ship) + ship
      x = rand(10)
    end

    #check if the area is available
    flag = true
    if dir == 0
      top_x = x - ship
      top_y = (y - 1 >= 0) ? y - 1 : 0
      bot_x = (x + 1 <= 9) ? x + 1 : 9
      bot_y = (y + 1 <= 9) ? y + 1 : 9
      for i in top_x..bot_x
        for j in top_y..bot_y
          if grid[i][j] == 1
            flag = false
          end
        end
      end
      if flag
        for i in x-ship+1..x
          grid[i][y] = 1
        end
      else
        place_ship(grid, ship)
      end
    else
      top_x = (x - 1 >= 0) ? x - ship : 0
      top_y = y - ship
      bot_x = (x + 1 <= 9) ? x + 1 : 9
      bot_y = (y + 1 <= 9) ? y + 1 : 9
      for i in top_x..bot_x
        for j in top_y..bot_y
          if grid[i][j] == 1
            flag = false
          end
        end
      end
      if flag
        for i in y-ship+1..y
          grid[x][i] = 1
        end
      else
        place_ship(grid, ship)
      end
    end
    return grid
  end

  def game_over?
    return true if player_a_ships == 0
    return true if player_b_ships == 0

    return false
  end

  # The do move method is intended to process player moves
  def do_move(x, y)

    if self.player_b_board[x][y] == 1
      self.player_b_board[x][y] = 3
      self.player_b_ships -= 1
      self.game_log = "#{self.player_a.name} shoots: #{y}:#{x} and hits the target!\n" + self.game_log
    else
      self.player_b_board[x][y] = 4
      self.game_log = "#{self.player_a.name} shoots: #{y}:#{x} and misses.\n" + self.game_log
    end

    set_play_status player_a
  end

  # Method that sets the play_status member
  def set_play_status(player)
    if game_over?
      # forced to use update_attributes explicitly?
      #self.winner = player
      self.update_attributes :winner => player
      self.game_log = "Game is over. #{player.name} celebrates the victory."

      if self.winner == self.player_a then
        self.play_status = "You have won this game. Congratulations!"
      else
        self.play_status = "You've lost to #{self.player_b.name}. Better luck next time!"
      end
    end
  end

  # Method that creates and returns application moves
  # Uses random numbers to determine what move to tr
  def create_move(x, y)

    if self.player_a_board[x][y] == 1
      self.player_a_board[x][y] = 3
      self.player_a_ships -= 1
      self.game_log = "#{self.player_b.name} shoots: #{y}:#{x} and hits the target!\n" + self.game_log
    else
      self.player_a_board[x][y] = 4
      self.game_log = "#{self.player_b.name} shoots: #{y}:#{x} and misses.\n" + self.game_log
    end

    set_play_status player_b
  end
end