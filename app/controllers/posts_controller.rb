class PostsController < ApplicationController
  impressionist actions: [:show],
                unique: [:impressionable_type, :impressionable_id, :session_hash]

  def home
    @hot_posts = Post.sort('Hot').limit(8)
    @new_posts = Post.sort('New').limit(8)
    @top_tags = Tag.top(10)
  end

  def index
    params[:scope] ||= 'Everything'
    params[:sort] ||= 'Hot'

    @posts = Post.scope(params[:scope], current_user)
                 .sort(params[:sort])
                 .page(params[:page])
                 .per(20)
  end

  def new
    preloaded = Cloudinary::PreloadedFile.new(params[:cloudinary_data])
    raise "Invalid upload signature" if !preloaded.valid?
    # @cloudinary_id = preloaded.identifier
    @post = Post.new(cloudinary_id: preloaded.identifier)
    @post.tag_list = current_user.default_tag_list
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to post_url(@post)
    else
      render 'new'
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
    params.require(:post).permit(:cloudinary_id, :title, :description, :tag_list, items_attributes: [:id, :name, :number, :x, :y, :_destroy])
  end
end
