module SessionsHelper
  def sign_in(worker)
    session[:worker_id] = worker.id
  end

  def remember(worker)
    worker.remember
    cookies.permanent.signed[:worker_id] = worker.id
    cookies.permanent[:remember_token] = worker.remember_token
  end

  def current_worker?(worker)
    worker == current_worker
  end

  def current_worker
    if (worker_id = session[:worker_id])
      @current_worker ||= Worker.find_by(id: worker_id)
    elsif (worker_id = cookies.signed[:worker_id])
      worker = Worker.find_by(id: worker_id)
      if worker && worker.authenticated?(:remember, cookies[:remember_token])
        sign_in worker
        @current_worker = worker
      end
    end
  end

  def signed_in?
    !current_worker.nil?
  end

  def forget(worker)
    worker.forget
    cookies.delete(:worker_id)
    cookies.delete(:remember_token)
  end

  def sign_out
    forget(current_worker) if current_worker.present?
    session.delete(:worker_id)
    @current_worker = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:forwading_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
