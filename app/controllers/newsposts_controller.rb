class NewspostsController < ApplicationController
  before_action :admin_account, only: [:edit, :update, :destroy]

  def new
    if !current_player.admin?
      redirect_to root_url
    end

    @newspost = Newspost.new
  end

  def show
    @newspost = Newspost.find_by(params[:id])
  end

  def create
    @newspost = Newspost.new(post_params)
    if @newspost.save
      flash[:success] = "Post created"
      redirect_to @newspost
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @newspost.update_attributes(post_params)
      flash[:success] = "Post updated"
      redirect_to @newspost
    else
      render 'edit'
    end
  end

  def destroy
    Newspost.find(params[:id]).destroy
    flash[:success] = "Post has been deleted"
    redirect_to root_url
  end

  private

  def post_params
    params.require(:newspost).permit(:title, :body)
  end

  def admin_account
    @newspost = Newspost.find(params[:id])
    redirect_to root_url unless current_player.admin?
  end
end
