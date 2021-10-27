require 'rails_helper'

describe 'バリデーションのテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:shrine) { create(:shrine) }
  let!(:other_shrine) { create(:shrine) }
  let!(:post) { create(:post, user: user, shrine: shrine) }
  let!(:other_post) { create(:post, user: other_user, shrine: shrine) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe '投稿作成画面のテスト' do
    before do
      visit new_shrine_post_path(shrine)
    end

    context '投稿失敗のテスト, 感想を入力しない' do
      before do
        @visit_date = Faker::Date.backward(days: 1)
        fill_in 'post[visit_date]', with: @visit_date
        attach_file('post[post_images_images][]', %W(#{Rails.root}/app/assets/images/no_image.jpg #{Rails.root}/app/assets/images/omairi.jpg))
      end

      it '投稿が保存されない' do
        expect { click_button '投稿する' }.not_to change(shrine.posts, :count)
      end
      it '投稿作成画面が表示され、フォームの内容が正しい' do
        click_button '投稿する'
        expect(page).to have_content '新規投稿'
        expect(page).to have_field 'post[body]', with: ''
        expect(page).to have_field 'post[visit_date]', with: @visit_date
      end
      it 'バリデーションエラーが表示される' do
        click_button '投稿する'
        expect(page).to have_content '感想を入力してください'
      end
    end

    context '投稿失敗のテスト, 参拝日を入力しない' do
      before do
        @body = Faker::Lorem.characters(number: 50)
        fill_in 'post[body]', with: @body
        attach_file('post[post_images_images][]', %W(#{Rails.root}/app/assets/images/no_image.jpg #{Rails.root}/app/assets/images/omairi.jpg))
      end

      it '投稿が保存されない' do
        expect { click_button '投稿する' }.not_to change(shrine.posts, :count)
      end
      it '投稿作成画面が表示され、フォームの内容が正しい' do
        click_button '投稿する'
        expect(page).to have_content '新規投稿'
        expect(page).to have_field 'post[body]', with: @body
        expect(page).to have_field 'post[visit_date]'
      end
      it 'バリデーションエラーが表示される' do
        click_button '投稿する'
        expect(page).to have_content '参拝日を入力してください'
      end
    end

    context '投稿失敗のテスト, 参拝日に未来の日付を入力する' do
      before do
        @body = Faker::Lorem.characters(number: 50)
        @visit_date = Faker::Date.forward(days: 1)
        fill_in 'post[body]', with: @body
        fill_in 'post[visit_date]', with: @visit_date
        attach_file('post[post_images_images][]', %W(#{Rails.root}/app/assets/images/no_image.jpg #{Rails.root}/app/assets/images/omairi.jpg))
      end

      it '投稿が保存されない' do
        expect { click_button '投稿する' }.not_to change(shrine.posts, :count)
      end
      it '投稿作成画面が表示され、フォームの内容が正しい' do
        click_button '投稿する'
        expect(page).to have_content '新規投稿'
        expect(page).to have_field 'post[body]', with: @body
        expect(page).to have_field 'post[visit_date]', with: @visit_date
      end
      it 'バリデーションエラーが表示される' do
        click_button '投稿する'
        expect(page).to have_content '参拝日に未来の日付は使用できません'
      end
    end
  end

  describe 'ログインしてない際のアクセス制限のテスト、アクセスできずログイン画面に遷移する' do
    before do
      logout_link = find_all('a')[59].native.inner_text
      click_link logout_link
    end
    subject { current_path }

    it 'ユーザ編集画面' do
      visit edit_user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it '退会確認画面' do
      visit users_caution_path
      is_expected.to eq '/users/sign_in'
    end
    it '投稿作成画面(sign_up画面に遷移する)' do
      visit new_shrine_post_path(shrine)
      is_expected.to eq '/users/sign_up'
    end
    it '投稿作成画面(遷移後にフラッシュメッセージが表示される)' do
      visit new_shrine_post_path(shrine)
      expect(page).to have_content '投稿するには会員登録が必要です'
    end
    it '投稿編集画面' do
      visit edit_shrine_post_path(post.shrine, post)
      is_expected.to eq '/users/sign_in'
    end
  end

  describe '他人のマイページのテスト' do
    before do
      visit user_path(other_user)
    end

    context '表示内容のテスト' do
      it 'urlが正しいか' do
        expect(current_path).to eq '/users/' + other_user.id.to_s
      end
      it 'ユーザの名前が表示されているか' do
        expect(page).to have_content other_user.name
      end
      it '編集画面へのリンクが表示されていない' do
        expect(page).not_to have_link '編集'
      end
      it 'フォローリンクが存在するか' do
        expect(page).to have_link 'フォロー', href: user_relationships_path(other_user)
      end
      it '他人の投稿の神社名が存在しリンクが正しいか' do
        expect(page).to have_link other_post.shrine.name, href: shrine_path(other_post.shrine)
      end
      it '他人の投稿の感想が存在しリンクが正しいか' do
        expect(page).to have_link other_post.body, href: shrine_post_path(other_post.shrine, other_post)
      end
      it '他人の投稿の参拝日が表示されているか' do
        expect(page).to have_content other_post.visit_date.strftime("%Y年%m月%d日")
      end
    end
  end

  context '他人の投稿編集画面のテスト' do
    it '遷移できず自分のマイページにリダイレクトされる' do
      visit edit_user_path(other_user)
      expect(current_path).to eq '/users/' + user.id.to_s
    end
  end

  describe '他人の投稿詳細画面のテスト' do
    before do
      visit shrine_post_path(other_post.shrine, other_post)
    end

    context '表示内容のテスト' do
      it 'urlが正しいか' do
        expect(current_path).to eq '/shrines/' + shrine.id.to_s + '/posts/' + other_post.id.to_s
      end
      it '他人の投稿の神社名が存在しリンクが正しい' do
        expect(page).to have_link other_post.shrine.name, href: shrine_path(other_post.shrine)
      end
      it '投稿者名が表示されマイページへのリンクが正しい' do
        expect(page).to have_link other_post.user.name, href: user_path(other_post.user)
      end
      it '他人の投稿の参拝日が表示されているか' do
        expect(page).to have_content other_post.visit_date.strftime("%Y年%m月%d日")
      end
      it '他人の投稿の感想が表示されている' do
        expect(page).to have_content other_post.body
      end
      it 'フォローリンクが存在するか' do
        expect(page).to have_link 'フォロー', href: user_relationships_path(other_post.user)
      end
      it '投稿の編集リンクが存在しない' do
        expect(page).not_to have_link '編集する'
      end
      it '投稿の削除リンクが存在しない' do
        expect(page).not_to have_link '削除する'
      end
    end

    context '他の人の投稿の欄に自分の投稿が表示されているか' do
      it '自分の投稿の写真と名前のリンクが正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
      end
      it '投稿の写真と本文のリンクが正しい' do
        expect(page).to have_link post.body, href: shrine_post_path(post.shrine, post)
      end
    end
  end

  context '他人の投稿編集画面のテスト' do
    it '遷移できず神社の一覧画面にリダイレクトされる' do
      visit edit_shrine_post_path(other_post.shrine, other_post)
      expect(current_path).to eq '/shrines'
    end
  end
end
