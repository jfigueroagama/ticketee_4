class SessionsController < ApplicationController
  
  def new 
  end
  
  def create
    # We need the [:signin][:email] to define the route for params => no session model
    user = User.where(email: params[:signin][:email]).first
    if user && user.authenticate(params[:signin][:password])
      # When the user signs in we save its id in the session hash
      session[:user_id] = user.id
      flash[:notice] = "Signed in successfully."
      redirect_to root_url
    else
      flash[:error] = "Sorry"
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:notice]= "Signed out successfully."
    redirect_to root_url
  end
  
end
