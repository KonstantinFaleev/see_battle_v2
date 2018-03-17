module GamesHelper

  def user_agent_ok?
    ua = request.env['HTTP_USER_AGENT']
    if ua.downcase.include? "msie"
      true
    elsif ua.downcase.include? "firefox"
      true
    elsif ua.downcase.include? "safari"
      false
    elsif ua.downcase.include? "chrome"
      false
    elsif ua.downcase.include? "dolphin"
      false
    else
      true
    end
  end
end