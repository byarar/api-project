class CommentsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :find_comment, only: [:show, :update, :destroy]

  # Path: GET /comments
  def index
    comments = Comment.all
    render json: comments
  end

  # Path: GET /comments/:id
  def show
    render json: @comment
  end

  # Path: POST /comments
  def create
    # Find the post using the post_id parameter
    post = Post.find(params[:comment][:post_id])

    # Now, create the comment and associate it with both the post and the current user
    comment = post.comments.create(comment_params.merge(user_id: current_user.id))

    if comment.save
      render json: comment, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Path: PATCH/PUT /comments/:id
  def update
    if @comment.user == current_user
      if @comment.update(comment_params)
        render json: @comment
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  # Path: DELETE /comments/:id
  def destroy
    if @comment.user == current_user
      @comment.destroy
      head :no_content
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:post_id, :body)
  end
end
