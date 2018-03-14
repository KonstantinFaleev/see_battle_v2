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

  def place_ship(x, y)
    #(x, y) is ship top left coordinate
    #direction: true-vertical, false-horizontal
    #check if ship crosses board borders
    ship_length = self.available_ships[0]
    coordinates_are_valid = false

    if direction
      if x+ship_length-1 > 9
        #coordinates are invalid
        coordinates_are_valid = false
      else
        for i in x..x+ship_length-1
          unless i < 0 || i > 9
            if self.grid[i][y][0] == 1 || self.grid[i][y][0] == 2
              coordinates_are_valid = false
              return
            end
          end
        end

        coordinates_are_valid = true
        ship = Ship.new(decks: ship_length)
        ship.save
        for i in x..x+ship_length-1
          self.grid[i][y][0] = 1
          self.grid[i][y][1] = ship
        end

        #disable nearest cells
        top_x = x-1 < 0 ? 0 : x-1
        top_y = y-1 < 0 ? 0 : y-1
        bot_x = x+ship_length > 9 ? 9 : x+ship_length
        bot_y = y+1 > 9 ? 9 : y+1
        for i in top_x..bot_x
          for j in top_y..bot_y
            self.grid[i][j][0] = 2 unless self.grid[i][j][0] == 1
          end
        end
      end
    else
      if y+ship_length-1 > 9
        #coordinates are invalid
        coordinates_are_valid = false
      else
        for i in y..y+ship_length-1
          unless i < 0 || i > 9
            if self.grid[x][i][0] == 1 || self.grid[x][i][0] == 2
              coordinates_are_valid = false
              return
            end
          end
        end

        coordinates_are_valid = true
        ship = Ship.new(decks: ship_length)
        ship.save
        for i in y..y+ship_length-1
          self.grid[x][i][0] = 1
          self.grid[x][i][1] = ship
        end

        #disable nearest cells
        top_x = x-1 < 0 ? 0 : x-1
        top_y = y-1 < 0 ? 0 : y-1
        bot_x = x+1 > 9 ? 9 : x+1
        bot_y = y+ship_length > 9 ? 9 : y+ship_length
        for i in top_x..bot_x
          for j in top_y..bot_y
            self.grid[i][j][0] = 2 unless self.grid[i][j][0] == 1
          end
        end
      end
    end

    if coordinates_are_valid
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
      end
    end
  end
end