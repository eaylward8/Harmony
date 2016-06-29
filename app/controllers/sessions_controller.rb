class SessionsController < ApplicationController
  skip_before_action :authorized?

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      binding.pry
      session[:user_id] = user.id
      redirect_to user_path(user)
    else
      flash[:error] = 'Email or password is invalid.'
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
