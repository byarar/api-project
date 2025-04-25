class PostsController < ApplicationController
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
    post = find_post
    render json: post.to_json(include: :comments)
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
    render json: post
  end

  # Path: PATCH/PUT /posts/:id
  # Path: PATCH/PUT /users/:user_id/posts/:id
  def update
    post = find_post
    post.update(post_params)
    render json: post
  end

  # Path: DELETE /posts/:id
  # Path: DELETE /users/:user_id/posts/:id
  def destroy
    post = find_post
    post.destroy
    head :no_content
  end

  private

  def find_post
    if params[:user_id]
      User.find(params[:user_id]).posts.find(params[:id])
    else
      Post.find(params[:id])
    end
  end

  def post_params
    params.require(:post).permit(:user_id, :title, :body)
  end  
end
