class RemoveIndexFromPlayerEmails < ActiveRecord::Migration[5.1]
  def change
    remove_index :players, :email
  end
end
