class PlayersController < ApplicationController
  before_action :signed_in_player, only: [:index, :edit, :update]
  before_action :correct_player, only: [:edit, :update]
  before_action :admin_account, only: :destroy

  def index
    if params[:search]
      @players = Player.search(params[:search])
    else
      @players = Player.paginate(page: params[:page])
    end
  end

  def new
    if  signed_in?
      redirect_to root_url
    end

    @player = Player.new
  end

  def show
    @player = Player.find(params[:id])
    @games = Game.where(["player_a_id = ? or player_b_id = ?", @player.id, @player.id]).load.paginate(:page => params[:page], :per_page => 10)

    # Game.find(:all, :conditions => ["winner_id = ?", self]).size
    # Game.find(:all, :conditions => ["player_x_id = ? and is_tie_game = true", self]).size
  end

  def create
    @player = Player.new(p_params)
    if @player.save
      sign_in @player
      flash[:success] = "Smooth sailing!"
      redirect_to @player
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @player.update_attributes(p_params)
      flash[:success] = "Profile updated"
      redirect_to @player
    else
      render 'edit'
    end
  end

  def destroy
    player = Player.find(params[:id])
    unless current_player?(player)
      a = Player.find(params[:id]).name
      Player.find(params[:id]).destroy
      flash[:success] = "Account '#{a}' has been deleted"
    else
      flash[:error] = "Salvation Through Destruction is not allowed :)"
    end
    redirect_to players_url
  end

  private

  def p_params
    params.require(:player).permit(:name, :email, :password, :password_confirmation)
  end

  def signed_in_player
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
  end

  def correct_player
    @player = Player.find(params[:id])
    redirect_to root_url unless current_player?(@player)
  end

  def admin_account
    redirect_to root_url unless current_player.admin?
  end
end