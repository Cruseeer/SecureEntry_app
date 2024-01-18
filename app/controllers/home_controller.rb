class HomeController < ApplicationController
  def index
    @rooms = current_user.rooms if user_signed_in?
  end
end
