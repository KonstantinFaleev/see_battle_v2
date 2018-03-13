class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  after_action :player_activity

  private

  def player_activity
    current_player.try(:touch, :last_response_at)
  end
end
