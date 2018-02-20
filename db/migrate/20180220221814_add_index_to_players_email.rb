class AddIndexToPlayersEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :players, :email, unique: true
  end
end
