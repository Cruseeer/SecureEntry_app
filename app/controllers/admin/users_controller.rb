# app/controllers/admin/users_controller.rb
module Admin
    class UsersController < ApplicationController
      before_action :verify_admin
  
      def new
        @user = User.new
      end
  
      def create
        @user = User.new(user_params)
        if @user.save
          redirect_to admin_users_path, notice: 'Użytkownik został utworzony.'
        else
          render :new
        end
      end

      def index
        @users = User.all
      end

      def edit
        @user = User.find(params[:id])
      end
    
      def update
        @user = User.find(params[:id])
        if @user.update(user_params)
          redirect_to admin_users_path, notice: 'Użytkownik został zaktualizowany.'
        else
          render :edit
        end
    end
  
      private
  
      def user_params
        params.require(:user).permit(:name, :login, :password, :password_confirmation, :isadmin)
      end
  
      def verify_admin
        unless current_user&.isadmin?
            flash[:alert] = "Nie masz uprawnień administratora."
            redirect_to root_path  # Przekieruj użytkownika gdzieś, gdzie może się zalogować lub gdzie indziej
          end
      end
    end
  end
  