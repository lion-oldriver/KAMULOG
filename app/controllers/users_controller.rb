class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    bookmarks = Bookmark.where(user_id: @user.id).pluck(:shrine_id)
    @bookmark_shrines = Shrine.find(bookmarks)
    @followings = @user.followings
    if params[:sort] == "latest"
      @posts = @user.posts.order(visit_date: :desc).includes(:shrine).page(params[:page]).per(10)
    else
      @posts = @user.posts.includes(:shrine).page(params[:page]).per(10)
    end
  end

  def edit
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to root_path
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def hide
    @user = current_user
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
