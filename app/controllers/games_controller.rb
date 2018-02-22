class GamesController < ApplicationController

  def show
    @game = Game.find(params[:id])
  end

  def create
    p1 = current_player
    p2 = Player.find_by_id(rand(Player.all.size) + 2)
    g = Game.start_game(p1, p2)
    redirect_to g
  end

  # The ajax callable action that is executed when the player drags
  # an X onto the tic tac toe board
  def receive_move
    @game = Game.find_by_id(params[:id])
    do_move_by_player params[:cell]

    do_move_by_application

    redirect_to @game
  end

  # The ajax callable action that is executed when the application drags
  # an O onto the tic tac toe board
  # Note that this action is called automatically right after the call to receive_move_by_player
  # receive_move_by_player sends back a javascript command to call the
  # javascript method doOnApplicationMove with a 2 second timeout


  # parses the x and y coordinates from the drop zone elements name
  # calls do_move with the coordinates and player x
  def do_move_by_player(cell)
    # parse the x and y coordinates out of the string
    # format is drop_{y}_{x} drop_0_1
    coordinates = cell.split('_')
    y = coordinates[0].to_i;
    x = coordinates[1].to_i;

    @game.do_move @game.player_a, x.to_i, y.to_i
    #if @game.valid? then
    #if @game.errors.empty? then
    @game.save
    #end
  end

  # creates the x and y coordinates by calling create_move on the game object
  # calls do_move with the coordinates and player o
  def do_move_by_application
    # create the applications move
    @game.create_move

    #if @game.valid? then
    #if @game.errors.empty? then
    @game.save
    #end
  end
end
