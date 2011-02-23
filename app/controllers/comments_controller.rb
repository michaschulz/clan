class CommentsController < ApplicationController
	load_and_authorize_resource
	
  def create
  	@post = Post.find(params[:post_id])
    @comment = @post.comments.build(params[:comment])
    @comment.user_id = current_user.id
    @comment.save
    redirect_to @post, :notice => "Antwort erfolgreich gesendet."
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
   @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      redirect_to @comment, :notice  => "Antwort erfolgreich angepasst."
    else
      render :action => 'edit'
    end
  end

  def destroy
  	@comment = Comment.find(:comment_id)
  	@comment.destroy
  	redirect_to @post, :notice => "Antwort erfolgreich gelöscht."
  end
end
