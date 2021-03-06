class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    bookmarks = Bookmark.where(user_id: @user.id).pluck(:shrine_id)
    @bookmark_shrines = Shrine.find(bookmarks)
    @followings = @user.followings
    if params[:sort] == "oldest" # 古い順にソート
      @posts = @user.posts.order(visit_date: :asc).includes(:shrine).page(params[:page]).per(10)
    else
      @posts = @user.posts.order(visit_date: :desc).includes(:shrine).page(params[:page]).per(10)
    end
  end

  def edit
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(@user)
    else
      if @user.update(user_params)
        redirect_to user_path(@user)
      else
        render "edit"
      end
    end
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
