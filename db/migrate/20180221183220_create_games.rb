class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.integer :player_a_id
      t.integer :player_b_id
      t.integer :winner_id

      t.timestamps
    end
  end
end
