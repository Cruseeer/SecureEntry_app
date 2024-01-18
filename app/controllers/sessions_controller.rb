class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(login: params[:login])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Zalogowano pomyślnie!'
    else
      flash.now[:alert] = 'Błąd logowania. Spróbuj ponownie.'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Wylogowano pomyślnie!'
  end
end
