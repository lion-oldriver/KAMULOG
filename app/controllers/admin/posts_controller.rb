class Admin::PostsController < ApplicationController
  layout 'admin_application'
  before_action :authenticate_admin!

  def show
    @post = Post.find(params[:id])
    @other_posts = Post.where(user_id: @post.user.id).where.not(id: @post.id).includes(:shrine, :post_images) #現在のユーザの他の投稿
  end

  def destroy
    post = Post.find(params[:id])
    shrine = post.shrine
    post.destroy
    redirect_to admin_shrine_path(shrine)
  end
end
