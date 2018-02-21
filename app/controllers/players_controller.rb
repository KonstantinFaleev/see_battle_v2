class PlayersController < ApplicationController

  def new
    @player = Player.new
  end

  def show
    @player = Player.find(params[:id])
  end

  def create
    @player = Player.new(p_params)
    if @player.save
      flash[:success] = "Smooth sailing!"
      redirect_to @player
    else
      render 'new'
    end
  end

  private

  def p_params
    params.require(:player).permit(:name, :email, :password, :password_confirmation)
  end
end
