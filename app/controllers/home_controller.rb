class HomeController < ApplicationController
  def index
    @rooms = current_user.rooms if user_signed_in?
  end

  def report_lost_card
    # Sprawdź, czy użytkownik już zgłosił zgubienie karty
    if current_user.lost_card.present?
      redirect_to root_path, alert: 'Już zgłosiłeś zgubienie karty.'
    else
      @user_lost_card = LostCard.create(user: current_user)
      redirect_to root_path, notice: 'Zgłoszono zgubienie karty.'
    end
  end
end
