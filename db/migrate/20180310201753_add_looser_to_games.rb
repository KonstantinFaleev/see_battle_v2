class AddLooserToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :looser_id, :integer
  end
end
