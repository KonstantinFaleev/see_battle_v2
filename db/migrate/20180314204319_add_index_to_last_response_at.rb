class AddIndexToLastResponseAt < ActiveRecord::Migration[5.1]
  def change
    add_index :players, :last_response_at
  end
end
