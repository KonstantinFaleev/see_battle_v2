class SessionsController < ApplicationController
  def new
    if signed_in?
      redirect_to root_path
    end
  end

  def create
    player = Player.where("lower(name) = ?", params[:session][:name].downcase).first
    if player && player.authenticate(params[:session][:password])
      sign_in player
      redirect_back_or player
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end