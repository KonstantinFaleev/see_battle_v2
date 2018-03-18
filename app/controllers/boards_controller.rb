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

    redirect_to root_url unless current_player == @board.player
  end

  def change_ship_direction
    @board = Board.find(params[:id])
    @board.change_ship_direction
    @board.save

    respond_to do |format|
      format.html { render 'boards/current_ship' }
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

  def update
    @board = Board.find(params[:id])
    if @board.update_attributes(board_params)
      if @board.saved
        @board.update_attribute('saved', false)
      else
        @board.update_attribute('saved', true)
      end
      respond_to do |format|
        format.html { render 'boards/save_button' }
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