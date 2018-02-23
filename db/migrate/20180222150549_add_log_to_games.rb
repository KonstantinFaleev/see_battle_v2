class AddLogToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :game_log, :text
  end
end
