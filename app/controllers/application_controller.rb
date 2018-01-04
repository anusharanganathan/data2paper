class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  # Adds Hyrax behaviors into the application controller
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController
  with_themed_layout '1_column'


  protect_from_forgery with: :exception

  # Override Devise method to redirect to dashboard after signing in
  def after_sign_in_path_for(_resource)
    if request.env.has_key?('omniauth.origin') and request.env['omniauth.origin']
      request.env['omniauth.origin']
    else
      '/'
    end
  end
end
