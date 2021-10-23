class SearchesController < ApplicationController
  def search
    model = params[:model]
    contents = params[:content].split(/[[:blank:]]+/).select(&:present?) # 検索ワードを分割する
    @shrines = Shrine.none # 空のモデルオブジェクトを作成
    # プルダウンで選択した値で場合分けを行いOR検索を行う
    if model == "shrine"
      contents.each do |content|
        @shrines = @shrines.or(Shrine.where("name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags))
      end
    elsif model == "god"
      contents.each do |content|
        @shrines = @shrines.or(Shrine.joins(:gods).where("god_name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags))
      end
    elsif model == "tag"
      contents.each do |content|
        @shrines = @shrines.or(Shrine.joins(:tags).where("tag_name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags))
      end
    end
    @shrines = Kaminari.paginate_array(@shrines).page(params[:page]).per(8) # 配列用のページネーション
  end
end
