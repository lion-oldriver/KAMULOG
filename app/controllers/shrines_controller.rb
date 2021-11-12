class ShrinesController < ApplicationController
  def index
    if params[:sort] == "views" # 閲覧数順にソート
      @shrines = Shrine.views.includes(:shrine_gods, :gods, :shrine_tags, :tags).page(params[:page]).per(6)
    elsif params[:sort] == "bookmarks" # ブックマーク数順にソート
      @shrines = Shrine.bookmarks.includes(:shrine_gods, :gods, :shrine_tags, :tags).page(params[:page]).per(6)
    elsif params[:sort] == "posts" # 投稿の多い順にソート
      @shrines = Shrine.posts.includes(:shrine_gods, :gods, :shrine_tags, :tags).page(params[:page]).per(6)
    else
      @shrines = Shrine.includes(:shrine_gods, :gods, :shrine_tags, :tags).page(params[:page]).per(6)
    end
    @posts = Post.order(visit_date: :desc).limit(5).includes(:user, :shrine, :post_images)
    @tags = Tag.find(Tag.pluck(:id).shuffle[0..9]) # タグを10件ランダムで抽出
  end

  def show
    @shrine = Shrine.find(params[:id])
    @near_shrine = @shrine.nearbys(20, units: :km)  # 半径20km以内の登録された神社を取得する
    gon.shrine = @shrine
    gon.shrines = @near_shrine
    @posts = Post.where(shrine_id: @shrine.id).order(visit_date: :desc).includes(:user, :shrine, :post_images).page(params[:page]).per(6)
    impressionist(@shrine, nil, unique: [:ip_address]) # 閲覧数をカウントする。IPアドレスで識別
  end

  def location
    lat = params[:lat]
    lng = params[:lng]
    @position_shrine = Shrine.near([lat.to_i, lng.to_i], 1000, units: :km)
  end
end
