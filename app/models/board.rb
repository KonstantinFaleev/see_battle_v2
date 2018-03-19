class Board < ActiveRecord::Base
  serialize(:available_ships, Array)
  serialize(:grid, Array)

  belongs_to :player
  validates :player_id, presence: true
  validates :title, presence: true

  def is_ready?
    available_ships.empty?
  end

  def change_ship_direction
    if self.direction
      self.direction = false
    else
      self.direction = true
    end
  end

  def initialize_board
    self.available_ships = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1]

    grid = []
    10.times do
      row = []
      10.times do
        row << [0, 0]
      end
      grid << row
    end
    self.grid = grid
  end


  #(x, y) is ship top left coordinate
  #direction: true-vertical, false-horizontal
  #grid element meanings:
  #0 - empty cell
  #1 - ship
  #2 - fobidden cells around the ship
  def place_ship(x, y)
    ship_length = self.available_ships[0]

    #check whether new ship crosses board borders or orther ship zone
    if coordinates_valid?(x, y, ship_length)

      #place ship
      ship = Ship.new(decks: ship_length)
      ship.save
      if self.direction
        for i in x..x+ship_length-1
          self.grid[i][y][0] = 1
          self.grid[i][y][1] = ship
        end
      else
        for i in y..y+ship_length-1
          self.grid[x][i][0] = 1
          self.grid[x][i][1] = ship
        end
      end

      self.available_ships.shift

      if is_ready?
        #board is ready, reset disabled cells
        for i in 0..9
          for j in 0..9
            if self.grid[i][j][0] == 2
              self.grid[i][j][0] = 0
            end
          end
        end
      else
        #disable nearest cells
        top_x = x-1 < 0 ? 0 : x-1
        top_y = y-1 < 0 ? 0 : y-1
        if self.direction
          bot_x = x+ship_length > 9 ? 9 : x+ship_length
          bot_y = y+1 > 9 ? 9 : y+1
        else
          bot_x = x+1 > 9 ? 9 : x+1
          bot_y = y+ship_length > 9 ? 9 : y+ship_length
        end
        for i in top_x..bot_x
          for j in top_y..bot_y
            self.grid[i][j][0] = 2 unless self.grid[i][j][0] == 1
          end
        end
      end
      return true
    else
      return false
    end
  end

  #check if ship crosses board borders
  #grid element meanings:
  #0 - empty cell
  #1 - ship
  #2 - fobidden cells around the ship
  def coordinates_valid?(x, y, ship_length)
    a = self.direction ? x : y

    if a+ship_length-1 > 9
      return false
    else
      for i in a..a+ship_length-1
        unless i < 0 || i > 9
          if self.direction
            if self.grid[i][y][0] == 1 || self.grid[i][y][0] == 2
              return false
            end
          else
            if self.grid[x][i][0] == 1 || self.grid[x][i][0] == 2
              return false
            end
          end
        end
      end
    end

    return true
  end
end