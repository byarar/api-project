class CommentsController < ApplicationController
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
    comment = find_comment
    render json: comment
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
    render json: comment
  end

  # Path: PATCH/PUT /comments/:id
  # Path: PATCH/PUT /posts/:post_id/comments/:id
  def update
    comment = find_comment
    comment.update(comment_params)
    render json: comment
  end

  # Path: DELETE /comments/:id
  # Path: DELETE /posts/:post_id/comments/:id
  def destroy
    comment = find_comment
    comment.destroy
    head :no_content
  end

  private

  def find_comment
    if params[:post_id]
      Post.find(params[:post_id]).comments.find(params[:id])
    else
      Comment.find(params[:id])
    end
  end

  def comment_params
    params.require(:comment).permit(:post_id, :body)
  end  
end
