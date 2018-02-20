class AddRatingToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :rating, :integer, :default => 100
  end
end
