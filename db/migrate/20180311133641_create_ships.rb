class CreateShips < ActiveRecord::Migration[5.1]
  def change
    create_table :ships do |t|
      t.integer :decks
      t.timestamps
    end
  end
end
