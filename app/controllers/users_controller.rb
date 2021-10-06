class UsersController < ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def cation
    @user = current_user
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
