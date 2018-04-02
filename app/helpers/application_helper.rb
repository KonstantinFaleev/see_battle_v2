module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "SeaBattle"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def top_players
    Player.all.limit(10).load
  end

  def online_players
    Player.where("last_response_at > ?", 10.minutes.ago).load
  end

  def latest_games
    Game.where.not(winner_id: '').limit(10).load
  end
end