module SessionsHelper
  def wb_user
    wb_user = Worker.find_by(email: params[:session][:email].downcase) || Client.find_by(email: params[:session][:email].downcase)
  end

  def user_type(user)
    if user.class == Worker
      'worker'
    elsif user.class == Client
      'client'
    else
      false
    end
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= Worker.find_by(id: user_id) || Client.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = Worker.find_by(id: user_id) || Client.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        sign_in user
        @current_user = user
      end
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def sign_out
    forget(current_user) if current_user.present?
    session.delete(:user_id)
    @current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:forwading_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
