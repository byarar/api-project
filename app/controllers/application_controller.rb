class ApplicationController < ActionController::API
  # Decodes the JWT token and returns a hash with indifferent access
  def decoded_token
    return nil if request.headers['Authorization'].blank?

    token = request.headers['Authorization'].split(' ').last
    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base).first
      decoded.with_indifferent_access # allows access with both string and symbol keys
    rescue JWT::DecodeError => e
      Rails.logger.warn "JWT Decode Error: #{e.message}"
      nil
    end
  end

  # Returns the current user based on the token in the request header
  def current_user
    @current_user ||= User.find_by(id: decoded_token[:user_id]) if decoded_token
  end

  # Ensures the user is authenticated before accessing certain routes
  def authorize_request
    unless current_user
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end
end