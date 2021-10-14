class ShrinesController < ApplicationController
  def index
    @shrines = Shrine.includes(:shrine_gods, :gods, :shrine_tags, :tags).page(params[:page]).per(5)
    @posts = Post.order(visit_date: :desc).limit(5).includes(:user, :shrine, :post_images)
    @tags = Tag.order("RANDOM()").limit(10)
  end

  def show
    @shrine = Shrine.find(params[:id])
    @near_shrine = @shrine.nearbys(2, units: :km)
    gon.shrine = @shrine
    gon.shrines = @near_shrine
    gon.api_key = ENV['API_KEY']
    @posts = Post.where(shrine_id: @shrine.id).order(visit_date: :desc).includes(:user, :shrine, :post_images).page(params[:page]).per(6)
    impressionist(@shrine, nil, unique: [:ip_address])
  end
end
