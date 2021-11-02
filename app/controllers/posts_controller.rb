class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def show
    @post = Post.find(params[:id])
    @other_posts = Post.where(user_id: @post.user.id).where.not(id: @post.id).includes(:shrine, :post_images) # 現在のユーザの他の投稿
    @other_user_posts = Post.where(shrine_id: @post.shrine.id).where.not(user_id: @post.user.id).includes(:user, :shrine, :post_images) # 同じ神社に対する他のユーザの投稿
  end

  def new
    @post = Post.new
    @shrine = Shrine.find(params[:shrine_id])
    unless user_signed_in?
      flash[:notice] = "投稿するには会員登録が必要です"
      redirect_to new_user_registration_path
    end
  end

  def create
    @shrine = Shrine.find(params[:shrine_id])
    @post = current_user.posts.new(post_params)
    @post.shrine_id = @shrine.id
    if @post.save
      redirect_to shrine_path(@shrine)
    else
      render "new"
    end
  end

  def edit
    @post = Post.find(params[:id])
    @shrine = @post.shrine
    unless @post.user == current_user
      redirect_to shrines_path
    end
  end

  def update
    @post = Post.find(params[:id])
    @shrine = @post.shrine
    if @post.user != current_user
      redirect_to shrine_path(@shrine)
    else
      if @post.update(post_params)
        redirect_to shrine_post_path(@shrine, @post)
      else
        render "edit"
      end
    end
  end

  def destroy
    post = Post.find(params[:id])
    shrine = post.shrine
    if post.user == current_user
      post.destroy
    end
    redirect_to shrine_path(shrine)
  end

  private

  def post_params
    params.require(:post).permit(:body, :visit_date, post_images_images: [])
  end
end
