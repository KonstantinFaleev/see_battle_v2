class AddPlayerABoardToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :player_a_board, :text
    add_column :games, :player_b_board, :text
  end
end
