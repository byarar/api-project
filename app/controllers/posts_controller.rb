class PostsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :find_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    posts = Post.all
    render json: posts
  end

  # GET /posts/:id
  def show
    render json: @post.to_json(include: :comments)
  end

  # POST /posts
  def create
    post = current_user.posts.build(post_params)
    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/:id
  def update
    if @post.user == current_user
      if @post.update(post_params)
        render json: @post
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  # DELETE /posts/:id
  def destroy
    if @post.user == current_user
      @post.destroy
      head :no_content
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
