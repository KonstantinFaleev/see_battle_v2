class GamesController < ApplicationController
  def show
    if signed_in?
      @game = Game.find(params[:id])
    else
      redirect_to signin_path, notice: "Please sign in."
    end
  end

  def create
    p1 = current_player
    p2 = Player.find_by_id(rand(Player.all.size) + 2)
    g = Game.start_game(p1, p2)
    redirect_to g
  end

  def receive_move
    @game = Game.find_by_id(params[:id])
    if(!@game.game_over?)
      do_move_by_player params[:cell]
      if(!@game.game_over?)
        do_move_by_application
      end
    end

    redirect_to @game
  end

  def do_move_by_player(cell)
    # parse the x and y coordinates out of the string
    # format is x_y
    coordinates = cell.split('_')
    x = coordinates[0].to_i;
    y = coordinates[1].to_i;

    @game.do_move x, y

    @game.save
  end

  # creates the move by application by calling create_move method
  def do_move_by_application
    x = rand(10)
    y = rand(10)

    while @game.player_a_board[x][y] == 3 || @game.player_a_board[x][y] == 4
      x = rand(10)
      y = rand(10)
    end

    @game.create_move x, y

    @game.save
  end
end