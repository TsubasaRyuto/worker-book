class StaticPagesController < ApplicationController
  def home; end

  def signup; end

  def verify_email
    if session[:verify_email]
      session[:verify_email] = nil
    else
      redirect_to root_path
    end
  end
end
