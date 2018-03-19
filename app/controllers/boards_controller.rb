class BoardsController < ApplicationController
  respond_to :html, :js

  def create
    @board = current_player.boards.build
    @board.initialize_board
    @board.save

    redirect_to @board
  end

  def show
    @board = Board.find(params[:id])
    @saved_boards = Board.where("player_id = ? AND saved = ?", @board.player_id, true).load

    redirect_to root_url unless current_player?(@board.player)
  end

  def change_ship_direction
    @board = Board.find(params[:id])
    @board.change_ship_direction
    @board.save

    respond_with 'boards/current_ship'
  end

  def place_ship
    @board = Board.find(params[:id])

    x,y = params[:cell].split('_')

    if @board.place_ship x.to_i, y.to_i
      @board.save
    end

    respond_with @board
  end

  def update
    @board = Board.find(params[:id])
    @board.update_attributes(board_params)
    respond_with 'board/save_button'
  end

  private

  def board_params
    params.require(:board).permit(:title, :saved)
  end
end