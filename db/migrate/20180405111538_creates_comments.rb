class CreatesComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :content
      t.integer :player_id
      t.integer :game_id

      t.timestamps
    end
    add_index :comments, [:player_id, :game_id, :created_at]
  end
end
