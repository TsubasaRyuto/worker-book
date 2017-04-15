class ErrorsController < ApplicationController
  layout 'application'
  rescue_from Exception, with: :error_500
  rescue_from ActiveRecord::RecordNotFound, with: :error_404
  rescue_from ActionController::UnknownController, with: :error_404
  rescue_from AbstractController::ActionNotFound, with: :error_404
  rescue_from ActionController::RoutingError, with: :error_404

  def error_500(exception = nil)
    logger.error "Rendering 500 with exception: #{exception.message}" if exception
    render 'errors/error_500', status: :internal_server_error, layout: 'application'
  end

  def error_404(exception = nil)
    logger.error "Rendering 404 with exception: #{exception.message}" if exception
    render 'errors/error_404', status: :not_found, layout: 'application'
  end

  def show
    raise env['action_dispatch.exception']
  end
end
