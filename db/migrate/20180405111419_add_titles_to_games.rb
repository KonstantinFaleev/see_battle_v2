class AddTitlesToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :title, :string
  end
end
