class CommentsController < ApplicationController
  before_action :signed_in_player, only: [:create, :destroy]
  before_action :correct_player,   only: :destroy
  before_action :admin, only: [:index, :approve]

  respond_to :html, :js

  def index
    @comments = Comment.not_approved
  end

  def create
    @comment = current_player.comments.build(comment_params)
    @game = Game.find_by(id: comment_params[:game_id])
    if @comment.save
      @comment = current_player.comments.build(game_id: @game.id)
      respond_with 'games/comments_area'
    end
  end

  def destroy
    @game = @comment.game
    @comment.destroy
    respond_with 'games/comments_area', 'shared/comment'
  end

  def approve
    @comment = Comment.find_by(id: params[:id])
    @comment.approved = true
    @comment.save
    redirect_to comments_path
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :game_id)
  end

  def correct_player
    @comment = Comment.find_by(id: params[:id])
    redirect_to root_url unless current_player?(@comment.player) || current_player.admin?
  end

  def admin
    redirect_to root_url unless current_player.admin?
  end
end