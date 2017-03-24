module SessionsHelper
  def sign_in(worker)
    session[:worker_id] = worker.id
  end

  def remember(worker)
    worker.remember
    cookies.permanent.signed[:worker_id] = worker.id
    cookies.permanent[:remember_token] = worker.remember_token
  end

  def current_worker
    if (worker_id = session[:user_id])
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

  def log_out
    forget(current_worker)
    session.deleted(:worker_id)
    @current_worker = nil
  end
end
