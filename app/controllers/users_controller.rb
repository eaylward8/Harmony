class UsersController < ApplicationController
  def show
    # Main user dashboard for prescription info / schedule
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    # Form to edit user profile
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: "Thank you for signing up!"
    else
      render 'new'
    end
  end

  def update
    # Updates user profile
  end

  def destroy
    # Destroys a user
  end

  private

  def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
end
