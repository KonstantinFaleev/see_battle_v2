class BoardsController < ApplicationController
  before_action :find_board, only: [:show, :change_ship_direction, :place_ship, :update]
  respond_to :html, :js

  def create
    @board = current_player.boards.build
    @board.initialize_board
    @board.save

    redirect_to @board
  end

  def show
    @saved_boards = Board.where("player_id = ? AND saved = ?", @board.player_id, true).load

    redirect_to root_url unless current_player?(@board.player)
  end

  def change_ship_direction
    @board.change_ship_direction
    @board.save
  end

  def place_ship
    x,y = params[:cell].split('_')

    if @board.place_ship x.to_i, y.to_i
      @board.save
    end

    respond_with @board
  end

  def update
    @board.update_attributes(board_params)
  end

  private

  def board_params
    params.require(:board).permit(:title, :saved)
  end

  def find_board
    @board = Board.find(params[:id])
  end
end