class SearchesController < ApplicationController
  def search
    method = params[:method]
    contents = params[:content].split(/[[:blank:]]+/).select(&:present?) # 検索ワードを分割する
    @shrines = Shrine.none # 空のモデルオブジェクトを作成
    if method == "multi" # 複数条件でOR検索
      @shrine_joins = Shrine.joins(:gods, :tags) # godsとtagsテーブルを結合する
      contents.each do |content|
        @shrines = @shrines.or(@shrine_joins.where("name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags))
        .or(@shrine_joins.where("god_name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags))
        .or(@shrine_joins.where("tag_name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags))
      end
    elsif method == "refined" # 絞り込み検索
      @shrines = Shrine # モデルオブジェクトの作成
      contents.each do |content|
        @shrines = @shrines.joins(:gods, :tags).where("name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags)
        .or(@shrines.joins(:gods, :tags).where("god_name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags))
        .or(@shrines.joins(:gods, :tags).where("tag_name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags))
      end
    end
    @shrines = Kaminari.paginate_array(@shrines).page(params[:page]).per(8) # 配列用のページネーション
  end
end
