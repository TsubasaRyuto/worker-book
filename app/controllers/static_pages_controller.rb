class StaticPagesController < ApplicationController
  def home; end

  def signup; end

  def worker_verify_email
    if session[:verify_email]
      session[:verify_email] = nil
    else
      redirect_to root_path
    end
  end

  def client_verify_email
    if session[:verify_email]
      session[:verify_email] = nil
    else
      redirect_to root_path
    end
  end

  def privacy_policy; end

  def terms; end
end
