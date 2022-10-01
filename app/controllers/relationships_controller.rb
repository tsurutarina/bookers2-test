class RelationshipsController < ApplicationController
  # フォローする
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end
  # リムる
  def destroy
    current_user.unfollow(params[:user_id])
    rect_to request.referer
  end
  # フォロー一覧
  def followings
    user =User.find(params[:user_id])
    @users = user.followongs
  end
  # フォロワ一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end

end
