class StaticPagesController < ApplicationController

  def home
    @newsposts = Newspost.all.paginate(page: params[:page], per_page: 5)
  end
end
