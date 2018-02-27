module GamesHelper

  def user_agent_ok?
    ua = request.env['HTTP_USER_AGENT']
    if ua.include? "MSIE"
      true
    elsif ua.include? "Firefox"
      true
    elsif ua.include? "safari"
      true
    elsif ua.include? "Chrome"
      false
    elsif ua.include? "dolphin"
      false
    else
      false
    end
  end
end
