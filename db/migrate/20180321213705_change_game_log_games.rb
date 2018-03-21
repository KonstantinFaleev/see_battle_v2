class ChangeGameLogGames < ActiveRecord::Migration[5.1]
  def change
    remove_column :games, :game_log, :text
    add_column :games, :game_log, :text, default: "Game has started."
  end
end
