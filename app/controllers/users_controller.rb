class UsersController < ApplicationController
  # Path: GET /users
  def index
    users = User.all
    render json: users
  end

  # Path: GET /users/:id
  def show
    user = find_user
    render json: user.to_json(include: :posts)
  end

  # Path: POST /users
  def create
    user = User.create(user_params)
    render json: user
  end

  # Path: PATCH/PUT /users/:id
  def update
    user = find_user
    user.update(user_params)
    render json: user
  end

  # Path: DELETE /users/:id
  def destroy
    user = find_user
    user.destroy
    head :no_content
  end

  private

  def find_user
    User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username)
  end
end
