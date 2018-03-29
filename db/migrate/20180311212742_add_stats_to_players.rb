class AddStatsToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :ships_lost, :integer, default: 0
    add_column :players, :ships_destroyed, :integer, default: 0
  end
end
