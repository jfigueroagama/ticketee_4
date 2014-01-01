class SessionsController < ApplicationController
  
  def new 
  end
  
  def create
    user = User.where(name: params[:signin][:name]).first
    if user && user.authenticate(params[:signin][:password])
      # when the user signs in we save its id in the session hash
      session[:user_id] = user.id
      flash[:notice] = "Signed in successfully."
      redirect_to root_url
    else
      flash[:error] = "Sorry"
      render :new
    end
  end
  
end
