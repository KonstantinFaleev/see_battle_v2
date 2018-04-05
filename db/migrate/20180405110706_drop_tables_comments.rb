class DropTablesComments < ActiveRecord::Migration[5.1]
  def change
    drop_table :comments
    drop_table :games
    drop_table :newsposts
    drop_table :players
    drop_table :ships
  end
end
