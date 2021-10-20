class SearchesController < ApplicationController
  def search
    @model = params["model"]
    @content = params["content"]
    @records = search_for(@model, @content).includes(:shrine_gods, :gods, :shrine_tags, :tags).page(params[:page]).per(10)
  end

  private

  def search_for(model, content)
    if model == "shrine"
      Shrine.where('name LIKE ?', '%' + content + '%') # 神社の名前で部分一致検索
    elsif model == "god"
      Shrine.joins(:gods).where('god_name LIKE ?', '%' + content + '%').distinct # 神様の名前で部分一致検索,重複レコードはまとめる
    elsif model == "tag"
      Shrine.joins(:tags).where('tag_name LIKE ?', '%' + content + '%').distinct # タグで部分一致検索,重複レコードはまとめる
    end
  end
end
