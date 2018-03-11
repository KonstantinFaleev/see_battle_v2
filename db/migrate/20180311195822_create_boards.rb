class CreateBoards < ActiveRecord::Migration[5.1]
  def change
    create_table :boards do |t|
      t.text :grid
      t.text :available_ships
      t.boolean :direction, default: false
      t.integer :player_id
      t.boolean :isSaved, default: false

      t.timestamps
    end
  end
end
