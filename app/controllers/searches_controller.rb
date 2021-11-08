class SearchesController < ApplicationController
  def search
    method = params[:method]
    contents = params[:content].split(/[[:blank:]]+/).select(&:present?) # 検索ワードを分割する
    @shrines = Shrine.none # 空のモデルオブジェクトを作成
    @shrine_joins = Shrine.joins(:gods, :tags) # godsとtagsテーブルを結合する
    if method == "multi" # 複数条件でOR検索
      contents.each do |content|
        @shrines = @shrines.or(@shrine_joins.search_multi(content))
      end
    elsif method == "refined" # 絞り込み検索
      @shrines = Shrine # モデルオブジェクトの作成
      contents.each do |content|
        @shrines = @shrines.search_refined(content)
      end
    end
    @shrines = Kaminari.paginate_array(@shrines).page(params[:page]).per(8) # 配列用のページネーション
  end
end
