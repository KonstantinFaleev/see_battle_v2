class ChangeIsOnlinePlayers < ActiveRecord::Migration[5.1]
  def change
    remove_column :players, :isOnline
    add_column :players, :last_response_at, :integer, :limit => 1
    add_index :players, :last_response_at
  end
end
