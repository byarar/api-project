class AuthenticationController < ApplicationController
  # POST /login
  def login
    user = User.find_by(username: params[:username])
    
    if user && user.authenticate(params[:password])
      token = encode_token(user.id)  # Generate the token
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private

  # Encode the user id into a JWT token
  def encode_token(user_id)
    JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base)
  end
end

