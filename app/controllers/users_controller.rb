class UsersController < ApplicationController
  def show
    params[:sort] ||= 'New'
    @user = User.find(params[:id])
    @posts = @user.posts.sort(params[:sort]).page(params[:page]).per(10)
    render 'posts/index_grid' if request.xhr?
  end

  def edit
    @user = current_user
  end

  def update
    if params[:cloudinary_data]
      preloaded = Cloudinary::PreloadedFile.new(params[:cloudinary_data])
      raise "Invalid upload signature" if !preloaded.valid?
      # @cloudinary_id = preloaded.identifier
      if current_user.update_attributes(avatar_cloudinary_id: preloaded.identifier)
        redirect_to current_user, notice: 'Avatar updated.'
      else
        #TODO
      end
    else
      if current_user.update_attributes(user_params)
        redirect_to current_user, notice: 'Profile updated.'
      else
        @active_tab = '#profile-edit'
        @user = current_user
        render 'edit'
      end
    end
  end

  # def check_email_uniqueness
  #   @user = User.where("email ILIKE ?", params[:user][:email]).first

  #   respond_to do |format|
  #     format.json { render json: !@user }
  #   end
  # end

  # def check_username_uniqueness
  #   @user = User.where("username ILIKE ?", params[:user][:username]).first

  #   respond_to do |format|
  #     format.json { render json: !@user }
  #   end
  # end

  private

  def user_params
    params.require(:user).permit(:username, :email, :full_name, :description)
  end
end
