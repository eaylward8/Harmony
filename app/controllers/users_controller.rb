class UsersController < ApplicationController
  def show
    # Main user dashboard for prescription info / schedule
    @user = User.find(params[:id])
  end

  def new
    # Form to make a new user
  end

  def edit
    # Form to edit user profile
  end

  def create
    # Creates a new user
  end

  def update
    # Updates user profile
  end

  def destroy
    # Destroys a user
  end
end
