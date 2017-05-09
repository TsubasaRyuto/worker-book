class SessionsController < ApplicationController
  def new; end

  def create
    @user = worker_book_user
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        sign_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirected
      else
        flash[:warning] = I18n.t('views.common.info.danger.not_activate_account')
        redirect_to root_url
      end
    else
      flash.now[:danger] = I18n.t('views.common.info.danger.sign_in_failed')
      render :new
    end
  end

  def destroy
    sign_out if signed_in?
    redirect_to root_url
  end

  private

  def redirected
    if @user.class == Worker
      if @user.profile.nil?
        redirect_to worker_create_profile_url(worker_username: @user.username)
      else
        redirect_back_or worker_url(username: @user.username)
      end
    elsif @user.class == ClientUser
      redirect_back_or client_url(clientname: @user.client.clientname)
    end
  end
end
