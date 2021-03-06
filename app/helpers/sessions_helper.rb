module SessionsHelper

  def sign_in(player)
    remember_token = Player.new_remember_token

    if params[:remember_me]
      cookies.permanent[:remember_token] = remember_token
    else
      cookies[:remember_token] = remember_token
    end

    player.update_attribute(:remember_token, Player.encrypt(remember_token))
    self.current_player = player
  end

  def current_player=(player)
    @current_player = player
  end

  def current_player
    remember_token = Player.encrypt(cookies[:remember_token])
    @current_player ||= Player.find_by(remember_token: remember_token)
  end

  def current_player?(player)
    current_player == player
  end

  def signed_in?
    !current_player.nil?
  end

  def signed_in_player
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def sign_out
    current_player.update_attribute(:remember_token, Player.encrypt(Player.new_remember_token))
    current_player.update_attribute(:last_response_at, nil)
    cookies.delete(:remember_token)
    self.current_player = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end