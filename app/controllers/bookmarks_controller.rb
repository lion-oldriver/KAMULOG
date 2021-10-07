class BookmarksController < ApplicationController
  def create
    @shrine = Shrine.find(params[:shrine_id])
    @bookmark = Bookmark.create(user_id: current_user.id, shrine_id: @shrine.id)
  end

  def destroy
    @shrine = Shrine.find(params[:shrine_id])
    @bookmark = Bookmark.find_by(user_id: current_user.id, shrine_id: @shrine.id)
    @bookmark.destroy
  end
end
