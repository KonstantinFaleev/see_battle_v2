class BoardsController < ApplicationController

  respond_to :html, :js

  def create
    @board = current_player.boards.build
    @board.available_ships = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1]
    grid = []
    10.times do
      row = []
      10.times do
        row << [0, 0]
      end
      grid << row
    end
    @board.grid = grid
    @board.save

    redirect_to @board
  end

  def show
    @board = Board.find(params[:id])
    @saved_boards = Board.where("player_id = ? AND isSaved = ?", @board.player_id, true).load

    redirect_to root_url unless current_player == @board.player
  end

  def change_ship_direction
    @board = Board.find(params[:id])
    @board.change_ship_direction
    @board.save

    respond_to do |format|
      format.html { redirect_to @board }
      format.js
    end
  end

  def place_ship
    @board = Board.find(params[:id])

    coordinates = params[:cell].split('_')
    x = coordinates[0].to_i;
    y = coordinates[1].to_i;

    @board.place_ship x, y
    @board.save

    respond_to do |format|
      format.html { redirect_to @board }
      format.js
    end
  end

  def forget_board
    @board = Board.find(params[:id])
    @board.update_attribute('isSaved', false)

    respond_to do |format|
      format.html { redirect_to @board }
      format.js
    end
  end

  def update
    @board = Board.find(params[:id])
    if @board.update_attributes(board_params)
      @board.update_attribute('isSaved', true)
      respond_to do |format|
        format.html { redirect_to @board }
        format.js
      end
    else
      render 'show'
    end
  end

  private

  def board_params
    params.require(:board).permit(:title)
  end
end
