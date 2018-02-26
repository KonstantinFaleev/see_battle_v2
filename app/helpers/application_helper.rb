module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Sea Battle"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def top_players
    Player.all.limit(10)
  end

  def online_players
    Player.where(:isOnline => true).load
  end
end