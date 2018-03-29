class ExpandGameModel < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :ai_moves_pull, :text
    add_column :games, :ai_neglected_moves, :text
  end
end
