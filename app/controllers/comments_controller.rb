class CommentsController < ApplicationController
  # Use before_action to find the comment before certain actions
  before_action :find_comment, only: [:show, :update, :destroy]

  # Path: GET /posts/:post_id/comments
  # Path: GET /comments
  def index
    comments = if params[:post_id]
                 post = Post.find(params[:post_id])
                 post.comments
               else
                 Comment.all
               end
    render json: comments
  end

  # Path: GET /posts/:post_id/comments/:id
  # Path: GET /comments/:id
  def show
    render json: @comment
  end

  # Path: POST /posts/:post_id/comments
  # Path: POST /comments
  def create
    comment = if params[:post_id]
                post = Post.find(params[:post_id])
                post.comments.create(comment_params)
              else
                Comment.create(comment_params)
              end

    if comment.save
      render json: comment, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Path: PATCH/PUT /comments/:id
  # Path: PATCH/PUT /posts/:post_id/comments/:id
  def update
    @comment.update(comment_params)
    render json: @comment
  end

  # Path: DELETE /comments/:id
  # Path: DELETE /posts/:post_id/comments/:id
  def destroy
    @comment.destroy
    head :no_content
  end

  private

  # Refactor find_comment to use before_action
  def find_comment
    @comment = if params[:post_id]
                 Post.find(params[:post_id]).comments.find(params[:id])
               else
                 Comment.find(params[:id])
               end
  end

  def comment_params
    params.require(:comment).permit(:post_id, :body)
  end  
end
