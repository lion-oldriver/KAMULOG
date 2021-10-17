require 'rails_helper'

describe 'ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:shrine) { create(:shrine) }
  let!(:other_shrine) { create(:shrine) }
  let!(:near_shrine) { create(:shrine) }
  let!(:post) { create(:post, user: user, shrine: shrine) }
  let!(:other_post) { create(:post, user: other_user, shrine: shrine) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe '神社一覧画面のテスト' do
    before do
      visit shrines_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/shrines'
      end
      it '神社の画像のリンク先が正しい' do
        expect(page).to have_link '', href: shrine_path(shrine)
        expect(page).to have_link '', href: shrine_path(other_shrine)
      end
      it '神社の名前のリンク先が正しい' do
        expect(page).to have_link shrine.name, href: shrine_path(shrine)
        expect(page).to have_link other_shrine.name, href: shrine_path(other_shrine)
      end
      it '神社の住所のリンク先が正しい' do
        expect(page).to have_link shrine.address, href: shrine_path(shrine)
        expect(page).to have_link other_shrine.address, href: shrine_path(other_shrine)
      end
      it '神社の紹介文が表示される' do
        expect(page).to have_content shrine.introduction
        expect(page).to have_content other_shrine.introduction
      end
    end

    context 'サイドバーの確認' do
      it '投稿者の写真と名前のリンク先が正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
        expect(page).to have_link other_post.user.name, href: user_path(other_post.user)
      end
      it '投稿の写真と本文のリンク先が正しい' do
        expect(page).to have_link post.body, href: shrine_post_path(post.shrine, post)
        expect(page).to have_link other_post.body, href: shrine_post_path(other_post.shrine, other_post)
      end
      it '投稿の参拝日が表示される' do
        expect(page).to have_content post.visit_date
        expect(page).to have_content other_post.visit_date
      end
    end
  end

  describe '神社詳細画面のテスト' do
    before do
      visit shrine_path(shrine)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/shrines/' + shrine.id.to_s
      end
      it '神社の名前が表示される' do
        expect(page).to have_content shrine.name
      end
      it '神社の紹介文が表示される' do
        expect(page).to have_content shrine.introduction
      end
      it '神社の住所が表示される' do
        expect(page).to have_content shrine.address
      end
    end

    context 'サイドバーの確認' do
      it '新規投稿へのリンク先が正しい' do
        expect(page).to have_link '投稿する', href: new_shrine_post_path(shrine)
      end
      it '投稿者の写真と名前のリンク先が正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
        expect(page).to have_link other_post.user.name, href: user_path(other_post.user)
      end
      it '投稿の写真と本文のリンク先が正しい' do
        expect(page).to have_link post.body, href: shrine_post_path(post.shrine, post)
        expect(page).to have_link other_post.body, href: shrine_post_path(other_post.shrine, other_post)
      end
      it '投稿の参拝日が表示される' do
        expect(page).to have_content post.visit_date
        expect(page).to have_content other_post.visit_date
      end
    end
  end

  describe '自分の投稿作成画面のテスト' do
    before do
      visit new_shrine_post_path(shrine)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/shrines/' + shrine.id.to_s + '/posts/new'
      end
      it '新規投稿と表示される' do
        expect(page).to have_content '新規投稿'
      end
      it '画像(複数)投稿フォームがあるか' do
        expect(page).to have_field 'post[post_images_images][]'
      end
      it '本文フォームがあるか' do
        expect(page).to have_field 'post[body]'
      end
      it '本文フォームは空になっているか' do
        expect(find_field('post[body]').text).to be_blank
      end
      it '投稿日フォームがあるか' do
        expect(page).to have_field 'post[visit_date]'
      end
      it '投稿ボタンが表示される' do
        expect(page).to have_button '投稿'
      end
    end

    context '投稿成功のテスト' do
      before do
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 50)
        fill_in 'post[visit_date]', with: Faker::Date.in_date_period
      end

      it '自分の投稿が正しく保存される' do
        expect { click_button '投稿' }.to change(shrine.posts, :count).by(1)
      end
    end
  end

  describe '投稿詳細画面のテスト' do
    before do
      visit shrine_post_path(post.shrine, post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/shrines/' + shrine.id.to_s + '/posts/' + post.id.to_s
      end
      it '神社の名前のリンクが正しい' do
        expect(page).to have_link post.shrine.name, href: shrine_path(post.shrine)
      end
      it '投稿者の写真と名前のリンクが正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
      end
      it '投稿の本文が表示される' do
        expect(page).to have_content post.body
      end
      it '編集のリンクがあるか' do
        expect(page).to have_link '編集する', href: edit_shrine_post_path(post.shrine, post)
      end
      it '削除のリンクがあるか' do
        expect(page).to have_link '削除する', href: shrine_post_path(post.shrine, post)
      end
    end

    context '他の人の投稿の確認' do
      it '投稿者の写真と名前のリンクが正しい' do
        expect(page).to have_link other_post.user.name, href: user_path(other_post.user)
      end
      it '投稿の写真と本文のリンク先が正しい' do
        expect(page).to have_link other_post.body, href: shrine_post_path(other_post.shrine, other_post)
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link '編集する'
        expect(current_path).to eq '/shrines/' + shrine.id.to_s + '/posts/' + post.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link '削除する'
      end

      it '正しく削除されるか' do
        expect(Post.where(id: post.id).count).to eq 0
      end
      it 'リダイレクト先が神社詳細画面になってる' do
        expect(current_path).to eq '/shrines/' + shrine.id.to_s
      end
    end
  end

  describe '投稿編集画面のテスト' do
    before do
      visit edit_shrine_post_path(post.shrine, post)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/shrines/' + shrine.id.to_s + '/posts/' + post.id.to_s + '/edit'
      end
      it '画像(複数)投稿フォームがあるか' do
        expect(page).to have_field 'post[post_images_images][]'
      end
      it 'body編集フォームが表示されているか' do
        expect(page).to have_field 'post[body]', with: post.body
      end
      it 'vist_date編集フォームが表示されているか' do
        expect(page).to have_field 'post[visit_date]', with: post.visit_date
      end
      it '変更するボタンが表示されている' do
        expect(page).to have_button '変更する'
      end
    end

    context '編集成功のテスト' do
      before do
        @post_old_body = post.body
        @post_old_visit_date = post.visit_date
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 50)
        fill_in 'post[visit_date]', with: Faker::Date.in_date_period
        click_button '変更する'
      end

      it 'bodyが正しく更新される' do
        expect(post.reload.body).not_to eq @post_old_body
      end
      it 'visit_dateが正しく更新される' do
        expect(post.reload.visit_date).not_to eq @post_old_visit_date
      end
      it 'リダイレクト先が更新した投稿の詳細画面になっているか' do
        expect(current_path).to eq '/shrines/' + shrine.id.to_s
      end
    end
  end

  describe 'マイページのテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end
      it '編集のリンクが正しい' do
        expect(page).to have_link '編集', href: edit_user_path(user)
      end
      it '自分の投稿の神社の名前が表示され、リンクが正しい' do
        expect(page).to have_link post.shrine.name, href: shrine_path(post.shrine)
      end
      it '投稿のbodyとvisit_dateが表示される' do
        expect(page).to have_content post.body
        expect(page).to have_content post.visit_date
      end
    end
  end
end