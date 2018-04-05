class InitialSchema < ActiveRecord::Migration[5.1]
  def change

    create_table :players, :force => true do |t|
      t.string   :name
      t.string   :email
      t.string   :password_digest
      t.string   :remember_token
      t.integer  :rating, default: 1000
      t.integer  :ships_lost, default: 0
      t.integer  :ships_destroyed, default: 0
      t.boolean  :admin, default: false
      t.datetime :last_response_at

      t.timestamps
    end

    add_index :players, :last_response_at
    add_index :players, :name, unique: true
    add_index :players, :remember_token

    create_table :boards, :force => true do |t|
      t.integer  :player_id
      t.text     :grid
      t.text     :available_ships
      t.boolean  :direction, default: false
      t.boolean  :saved, default: false
      t.string   :title, default: "No title"

      t.timestamps
    end

    create_table :games, :force => true do |t|
      t.integer  :player_a_id
      t.integer  :player_b_id
      t.integer  :winner_id
      t.integer  :looser_id
      t.integer  :player_a_ships, default: 20
      t.integer  :player_b_ships, default: 20
      t.string   :play_status
      t.text     :player_a_board
      t.text     :player_b_board
      t.text     :game_log, default: "Game has started."
      t.text     :ai_moves_pull
      t.text     :ai_neglected_moves

      t.timestamps
    end

    create_table :ships, :force => true do |t|
      t.integer  :decks

      t.timestamps
    end

    create_table :newsposts, :force => true do |t|
      t.string   :title
      t.text     :body

      t.timestamps
    end

  end
end
