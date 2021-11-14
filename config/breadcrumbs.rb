crumb :top do
  link "トップ", root_path
end

crumb :manner do
  link "参拝作法", manner_path
  parent :top
end

crumb :shrines do
  link "神社一覧", shrines_path
  parent :top
end

crumb :shrine do |shrine|
  link "#{shrine.name}", shrine_path(shrine)
  parent :shrines
end

crumb :shrine_post do |post|
  link "#{post.user.name}さんの投稿", shrine_post_path(post.shrine, post)
  parent :shrine, post.shrine
end

crumb :edit_post do |post|
  link "投稿編集", edit_shrine_post_path(post.shrine, post)
  parent :shrine_post, post
end

crumb :new_post do |shrine|
  link "新規投稿", new_shrine_post_path(shrine, shrine.posts)
  parent :shrine, shrine
end

crumb :user do |user|
  link "#{user.name}さんのページ", user_path(user)
  parent :top
end

crumb :user_edit do |user|
  link "ユーザ登録情報の編集", edit_user_path(user)
  parent :user, user
end

crumb :user_caution do |user|
  link "退会確認", users_caution_path
  parent :user_edit, current_user
end

crumb :search do
  link "検索結果", search_path
  parent :shrines
end

crumb :location do
  link "現在地周辺の神社", location_path
  parent :shrines
end
