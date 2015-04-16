class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params[:comment])

    if @comment.save
      respond_to do |format|
        format.html { redirect_to(post_path(@post), :notice => "Comment added") }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'posts/show' }
        format.js
      end
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to(post_path(@post), :notice => "Comment deleted")
  end

end
