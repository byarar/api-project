class PostsController < ApplicationController
  # Use before_action to find the post before certain actions
  before_action :find_post, only: [:show, :update, :destroy]

  # Path: GET /users/:user_id/posts
  # Path: GET /posts
  def index
    posts = if params[:user_id]
              User.find(params[:user_id]).posts
            else
              Post.all
            end
    render json: posts
  end

  # Path: GET /users/:user_id/posts/:id
  # Path: GET /posts/:id
  def show
    render json: @post.to_json(include: :comments)
  end

  # Path: POST /users/:user_id/posts
  # Path: POST /posts
  def create
    post = if params[:user_id]
             user = User.find(params[:user_id])
             user.posts.create(post_params)
           else
             Post.create(post_params)
           end

    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Path: PATCH/PUT /posts/:id
  # Path: PATCH/PUT /users/:user_id/posts/:id
  def update
    @post.update(post_params)
    render json: @post
  end

  # Path: DELETE /posts/:id
  # Path: DELETE /users/:user_id/posts/:id
  def destroy
    @post.destroy
    head :no_content
  end

  private

  # Refactor find_post to use before_action
  def find_post
    @post = if params[:user_id]
              User.find(params[:user_id]).posts.find(params[:id])
            else
              Post.find(params[:id])
            end
  end

  def post_params
    params.require(:post).permit(:user_id, :title, :body)
  end  
end
