class GamesController < ApplicationController
  before_action :find_game, only: [:show, :receive_move, :surrender]
  before_action :signed_in_player, only: [:show]

  respond_to :html, :js

  def create
    @game = Game.start_game(current_player, Player.find_by_id(2), params[:board_id])
    redirect_to games_path(@game)
  end

  def show
    #redirect_to "http://www.rubyonrails.org"
    @comment = current_player.comments.build(game_id: @game.id)
  end

  def receive_move
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
    @game.surrender_game
    redirect_to @game
  end

  private

  def find_game
    @game = Game.find(params[:id])
  end

  def do_move_by_player(cell)
    # parse the x and y coordinates out of the string
    # format is x_y
    x, y = cell.split('_')
    @game.do_move @game.player_a, x.to_i, y.to_i
  end

  # creates the move by application by randomizing x,y and calling do_move method
  def do_move_by_application
    x, y = @game.get_move_for_ai
    @game.do_move @game.player_b, x, y
  end
end