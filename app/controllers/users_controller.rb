class UsersController < ApplicationController
  before_action :find_user, only: [:show, :update, :destroy]

  # Path: GET /users
  def index
    users = User.all
    render json: users
  end

  # Path: GET /users/:id
  def show
    render json: @user.to_json(include: :posts)
  end

  # Path: POST /users
  def create
    user = User.create(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Path: PATCH/PUT /users/:id
  def update
    @user.update(user_params)
    render json: @user
  end

  # Path: DELETE /users/:id
  def destroy
    @user.destroy
    head :no_content
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end
end