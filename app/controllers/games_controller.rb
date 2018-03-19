class GamesController < ApplicationController
  before_action :signed_in_player, only: [:show]

  respond_to :html, :js

  def show
    @game = Game.find(params[:id])
  end

  def create
    if params[:board_id].blank?
      g = Game.start_game(current_player, Player.find_by_id(2), nil)
    else
      g = Game.start_game(current_player, Player.find_by_id(2), params[:board_id])
    end

    redirect_to g
  end

  def receive_move
    @game = Game.find_by_id(params[:id])
    if current_player == @game.player_a
      if(!@game.game_over?)
        do_move_by_player params[:cell]
        if(!@game.game_over? && !@game.move_again)
          do_move_by_application
          while(@game.move_again && !@game.game_over?)
            do_move_by_application
          end
        end
      end
    end

    respond_with 'games/game_area', 'layouts/top_button'
  end

  def surrender
    @game = Game.find_by_id(params[:id])
    @game.surrender_game
    @game.save

    redirect_to @game
  end

  def do_move_by_player(cell)
    # parse the x and y coordinates out of the string
    # format is x_y
    x,y = cell.split('_')
    @game.do_move @game.player_a, x.to_i, y.to_i
    @game.save
  end

  # creates the move by application by randomizing x,y and calling do_move method
  def do_move_by_application
    x, y = @game.get_move_for_ai
    @game.do_move @game.player_b, x, y
    @game.save
  end

  private

  def signed_in_player
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
  end
end