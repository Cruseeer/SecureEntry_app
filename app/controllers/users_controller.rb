class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Użytkownik został pomyślnie zarejestrowany.'
    else
      render :new
    end
  end

  def edit
    # Możesz dostosować tę akcję zgodnie z potrzebami (np. aktualizacja hasła, edycja profili itp.)
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: 'Dane użytkownika zostały pomyślnie zaktualizowane.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Użytkownik został pomyślnie usunięty.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :login, :password, :password_confirmation)
  end
end