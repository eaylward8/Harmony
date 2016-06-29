class WelcomeController < ApplicationController
  skip_before_action :authorized?

  def index
    @user = User.new
  end
  
end