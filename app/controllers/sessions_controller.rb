class SessionsController < ApplicationController
  def new; end

  def create
    worker = Worker.find_by(email: params[:session][:email].downcase)
    if worker && worker.authenticate(params[:session][:password])
      if worker.activated?
        sign_in worker
        params[:session][:remember_me] == '1' ? remember(worker) : forget(worker)
        redirect_to worker
      else
        flash[:warning] = ''
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'サインイン認証に失敗しました。もう一度やり直してください。'
      render :new
    end
  end

  def destroy
    sign_out if signed_in?
    redirect_to root_url
  end
end
