class CreateMoves < ActiveRecord::Migration[5.1]
  def change
    create_table :moves do |t|
      t.column :title, :string, :limit => 100, :null => false

      t.column :game_id, :int, :null => false
      t.column :player_id, :int, :null => false
      t.column :x_axis, :int, :null => false
      t.column :y_axis, :int, :null => false

      t.timestamps
    end
  end
end
