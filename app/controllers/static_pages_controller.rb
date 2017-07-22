class StaticPagesController < ApplicationController
  before_action :signed_in_user, only: [:signup]

  def home; end

  def about; end

  def guide; end

  def charge; end

  def service_rule; end

  def client; end

  def worker; end

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

  def guideline; end

  private

  def signed_in_user
    if signed_in?
      if current_user.class == Worker
        if current_user.profile.nil?
          redirect_to worker_create_profile_url(worker_username: current_user.username)
        else
          redirect_to worker_url(username: current_user.username)
        end
      elsif current_user.class == ClientUser
        redirect_to client_url(clientname: current_user.client.clientname)
      end
    end
  end
end
