class FollowRelationshipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @user = User.find(params[:follow_relationship][:followed_id])
    current_user.follow!(@user)

    respond_to do |format|
      format.html { redirect_to @user }
      format.js { @user.reload }
    end
  end

  def destroy
    @user = FollowRelationship.find(params[:id]).followed
    current_user.unfollow!(@user)

    respond_to do |format|
      format.html { redirect_to @user }
      format.js { @user.reload }
    end
  end
end
