class ShrinesController < ApplicationController
  def index
    if params[:sort] == "views"
      @shrines = Shrine.views.includes(:shrine_gods, :gods, :shrine_tags, :tags).page(params[:page]).per(5)
    elsif params[:sort] == "bookmarks"
      @shrines = Shrine.bookmarks.includes(:shrine_gods, :gods, :shrine_tags, :tags).page(params[:page]).per(5)
    else
      @shrines = Shrine.includes(:shrine_gods, :gods, :shrine_tags, :tags).page(params[:page]).per(5)
    end
    @posts = Post.order(visit_date: :desc).limit(5).includes(:user, :shrine, :post_images)
    @tags = Tag.find(Tag.pluck(:id).shuffle[0..9]) # タグを10件ランダムで抽出
  end

  def show
    @shrine = Shrine.find(params[:id])
    @near_shrine = @shrine.nearbys(5, units: :km)  # 半径5km以内の神社を取得する
    gon.shrine = @shrine
    gon.shrines = @near_shrine
    @posts = Post.where(shrine_id: @shrine.id).order(visit_date: :desc).includes(:user, :shrine, :post_images).page(params[:page]).per(6)
    impressionist(@shrine, nil, unique: [:ip_address]) # 閲覧数をカウントする。IPアドレスで識別
  end
end
