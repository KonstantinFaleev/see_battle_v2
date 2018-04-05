class AddDeletedsAtToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :deleted_at, :datetime
    add_index :players, :deleted_at
  end
end
