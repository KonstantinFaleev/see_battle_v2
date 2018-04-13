class PlayersController < ApplicationController
  before_action :signed_in_player, only: [:index, :edit, :update]
  before_action :correct_player, only: [:edit, :update]
  before_action :destroy_action, only: :destroy
  before_action :find_player, only: [:show, :destroy, :comments]

  def index
    if params[:search]
      @players = Player.search(params[:search]).paginate(page: params[:page], per_page: 10)
    else
      @players = Player.all.paginate(page: params[:page], per_page: 10)
    end
  end

  def new
    if  signed_in?
      redirect_to root_url
    end

    @player = Player.new
  end

  def show
    @saved_boards = Board.where("player_id = ? AND saved = ?", @player.id, true).load.paginate(page: params[:page], per_page: 10)
    @games = Game.where(["player_a_id = ? or player_b_id = ?", @player.id, @player.id]).load.paginate(page: params[:page], per_page: 10)
  end

  def comments
  end

  def forgotten
  end

  def create_new_password
    @player = Player.find_by(email: params[:email])
    if @player
      random_password = Array.new(10).map { (65 + rand(58)).chr }.join
      @player.password = random_password
      @player.password_confirmation = random_password
      @player.save!
      PlayerMailer.create_and_deliver_password_change(@player, random_password).deliver!
    else
      redirect_to root_url, notice: "You must enter a valid email address"
      return
    end
    redirect_to root_url, notice: "New password has been sent to your email."
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
    unless @player.admin?
      Player.find(params[:id]).destroy
      flash[:success] = "Account '#{@player.name}' has been deleted."
    else
      flash[:danger] = "Admin accounts cannot be deleted."
    end

    if current_player.admin?
      redirect_to players_url
    else
      redirect_to root_url
    end
  end

  private

  def p_params
    params.require(:player).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_player
    @player = Player.find(params[:id])
    redirect_to root_url unless current_player?(@player)
  end

  def destroy_action
    redirect_to root_url unless current_player.admin? || current_player == Player.find(params[:id])
  end

  def find_player
    @player = Player.find(params[:id])
  end
end