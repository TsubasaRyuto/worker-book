class SessionsController < ApplicationController
  def new; end

  def create
    user = wb_user
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        sign_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        if user.profile.nil?
          redirect_to "/#{user_type(user)}/#{user.username}/create_profile"
        else
          redirect_back_or "/#{user_type(user)}/#{user.username}"
        end
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
end
