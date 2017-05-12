class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include WorkerProfilesHelper

  def I18n.t(code, options = {})
    begin
      message_code = code
      normal_translated = super message_code, options
      translated = eval("\"#{normal_translated}\"")
      return translated
    rescue SyntaxError => ex
      return normal_translated
    end
  end
end
