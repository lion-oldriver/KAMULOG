class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
    @other_posts = Post.where(user_id: @post.user.id).where.not(shrine_id: @post.shrine.id).includes(:shrine, :post_images)
    shrine_posts = Post.where(shrine_id: @post.shrine.id)
    @other_user_posts = shrine_posts.where.not(user_id: @post.user.id)
  end

  def new
    @post = Post.new
    @shrine = Shrine.find(params[:shrine_id])
  end

  def create
    @shrine = Shrine.find(params[:shrine_id])
    post = current_user.posts.new(post_params)
    post.shrine_id = @shrine.id
    post.save
    redirect_to shrine_path(@shrine)
  end

  def edit
    @post = Post.find(params[:id])
    @shrine = Shrine.find(params[:shrine_id])
  end

  def update
    post = Post.find(params[:id])
    shrine = post.shrine
    if post.update(post_params)
      redirect_to shrine_path(shrine)
    else
      render 'edit'
    end
  end

  def destroy
    post = Post.find(params[:id])
    shrine = post.shrine
    post.destroy
    redirect_to shrine_path(shrine)
  end


  private
  def post_params
    params.require(:post).permit(:body, :visit_date, post_images_images: [])
  end
end
