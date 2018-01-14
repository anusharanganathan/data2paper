module API
  class APIBaseController < ApplicationController
    protect_from_forgery if: :json_request # return null session when API call
    before_action :authenticate_request, if: :json_request
    
    attr_reader :current_user
    
    private
    
    def authenticate_request
      @current_user = AuthorizeApiRequest.call(request.headers).result
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end
  end
end
