class AddPlayStatusToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :play_status, :string
  end
end
