class ShrinesController < ApplicationController
  def index
    @shrines = Shrine.includes(:shrine_gods, :gods, :shrine_tags, :tags)
    @posts = Post.order(visit_date: :desc).limit(5).includes(:user, :shrine, :post_images)
    @tags = Tag.order("RANDOM()").limit(10)
  end

  def show
    @shrine = Shrine.find(params[:id])
    @near_shrine = @shrine.nearbys(2, units: :km)
    gon.shrine = @shrine
    gon.shrines = @near_shrine
    @posts = Post.where(shrine_id: @shrine.id).includes(:user, :shrine, :post_images)
    impressionist(@shrine, nil, unique: [:ip_address])
  end
end
