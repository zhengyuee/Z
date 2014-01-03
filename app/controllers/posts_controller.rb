class PostsController < ApplicationController
  def index
    sleep(0.5) # temporary code to simulate real internet latency
    if params[:user_id]
      @user = User.find(params[:user_id])
      @posts = @user.posts.page(params[:page]).per(1)
      if request.xhr?
        render 'index_grid'
      else
        render 'index_user'
      end
    else
      @posts = Post.scope(params, current_user).page(params[:page]).per(2) # only 2 posts a page to test infinite scroll
    end

    if params[:view] == 'grid'
      render 'index_grid'
    end
  end

  def new
    preloaded = Cloudinary::PreloadedFile.new(params[:cloudinary_data])
    raise "Invalid upload signature" if !preloaded.valid?
    # @cloudinary_id = preloaded.identifier
    @post = Post.new(cloudinary_id: preloaded.identifier)
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to post_url(@post)
    else
      #TODO
    end
  end

  def show
    @post = Post.includes(:items).find(params[:id])
    @user = @post.user
    @comments = @post.comments.includes(:user)
    @comment = @post.comments.build
  end

  def edit
    @post = Post.find(params[:id])
    render 'new'
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      redirect_to post_url(@post)
    else
      #TODO
    end
  end

  private

  def post_params
    params.require(:post).permit(:cloudinary_id, :title, :description, items_attributes: [:id, :name, :number, :x, :y, :_destroy])
  end
end
