class PostsController < ApplicationController
	before_filter :authenticate_user!, :except => [:show, :index] 
	load_and_authorize_resource
	
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    @post.user_id = current_user.id
    authorize! :create, @post
    if @post.save
      redirect_to @post, :notice => "Nachricht erfolgreich gesendet."
    else
      render :action => 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
    authorize! :edit, @post
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect_to @post, :notice  => "Nachricht erfolgreich geändert."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize! :destroy, @post
    @post.destroy
    redirect_to posts_url, :notice => "Nachricht erfolgreich gelöscht."
  end
end
