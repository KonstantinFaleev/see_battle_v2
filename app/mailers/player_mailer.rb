class PlayerMailer < ActionMailer::Base
  default from: "letitbe400@gmail.com"

  def create_and_deliver_password_change(player, randompassword)
    @password = randompassword
    mail(:to => player.email, :subject=> "Password Recovery")
  end
end