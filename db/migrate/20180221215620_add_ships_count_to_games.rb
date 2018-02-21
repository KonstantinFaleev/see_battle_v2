class AddShipsCountToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :player_a_ships, :integer, default: 20
    add_column :games, :player_b_ships, :integer, default: 20
  end
end
