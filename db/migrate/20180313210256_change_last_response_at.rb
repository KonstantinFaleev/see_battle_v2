class ChangeLastResponseAt < ActiveRecord::Migration[5.1]
  def change
    remove_column :players, :last_response_at, :integer
    add_column :players, :last_response_at, :timestamp
  end
end
