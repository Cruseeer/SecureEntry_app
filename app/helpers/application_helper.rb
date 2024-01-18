# app/helpers/application_helper.rb
module ApplicationHelper
    def user_signed_in?
      !!session[:user_id]
    end
  
    def current_user
      User.find(session[:user_id]) if user_signed_in?
    end
  end
  