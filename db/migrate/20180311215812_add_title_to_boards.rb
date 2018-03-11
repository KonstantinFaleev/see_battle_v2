class AddTitleToBoards < ActiveRecord::Migration[5.1]
  def change
    add_column :boards, :title, :string, default: "No title"
  end
end
