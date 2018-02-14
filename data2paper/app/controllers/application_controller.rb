class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?

  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  # Adds Hyrax behaviors into the application controller
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController

  include Hyrax::DashboardHelperBehavior

  with_themed_layout '1_column'

  protect_from_forgery with: :exception, unless: :json_request
  
  # Override Devise method to redirect to dashboard after signing in
  def after_sign_in_path_for(resource_or_scope)
    if number_of_works(current_user) > 2
      new_path = '/dashboard/my/works'
    else
      new_path = '/'
    end
    stored_path = stored_location_for(resource_or_scope)
    if request.env.has_key?('omniauth.origin') and 
      request.env['omniauth.origin'].present? and request.env['omniauth.origin'] != '/'
      request.env['omniauth.origin']
    elsif stored_path.present? && stored_path.split("?")[0] == '/'
      new_path
    else
      stored_path || new_path
    end
  end

  protected

    def json_request
      request.format.json?
    end

  private
    # Its important that the location is NOT stored if:
    # - The request method is not GET (non idempotent)
    # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an 
    #    infinite redirect loop.
    # - The request is an Ajax request as this can lead to very unexpected behaviour.
    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr? && !request.fullpath.include?('admin/sign_in')
    end

    def store_user_location!
      # :user is the scope we are authenticating
      store_location_for(:user, request.fullpath)
    end
end
