require 'rails_helper'

describe 'トップページ' do
  describe 'Topページのテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'urlは正しいか' do
        expect(current_path).to eq '/'
      end
    end
  end

  describe 'ヘッダーのテスト(ログイン前）' do
    before do
      visit new_user_session_path
    end

    context '表示内容のテスト' do
      it 'ロゴのリンクはあるか' do
        logo_link = find_all('a')[0].native.inner_text
        expect(logo_link).to match("")
      end
      it '概要のリンクはあるか' do
        about_link = find_all('a')[1].native.inner_text
        expect(about_link).to match(/概要/i)
      end
      it '神社のリンクはあるか' do
        shrine_link = find_all('a')[2].native.inner_text
        expect(shrine_link).to match(/神社/i)
      end
      it '新規登録のリンクはあるか' do
        sign_up_link = find_all('a')[58].native.inner_text
        expect(sign_up_link).to match(/新規登録/i)
      end
      it 'ログインのリンクはあるか' do
        sign_in_link = find_all('a')[59].native.inner_text
        expect(sign_in_link).to match(/ログイン/i)
      end
    end

    context 'リンクの遷移先のテスト' do
      subject { current_path }

      it 'ロゴのリンクは正しいか' do
        logo_link = find_all('a')[0].native.inner_text
        click_link logo_link, match: :first
        is_expected.to eq '/'
      end
      it '概要のリンクは正しいか' do
        about_link = find_all('a')[1].native.inner_text
        click_link about_link
        is_expected.to eq '/home/about'
      end
      it '神社のリンクはあるか' do
        shrine_link = find_all('a')[2].native.inner_text
        click_link shrine_link
        is_expected.to eq '/shrines'
      end
      it '新規登録のリンクは正しいか' do
        signin_link = find_all('a')[58].native.inner_text
        click_link signin_link
        is_expected.to eq '/users/sign_up'
      end
      it 'ログインのリンクは正しいか' do
        signup_link = find_all('a')[59].native.inner_text
        click_link signup_link
        is_expected.to eq '/users/sign_in'
      end
    end
  end

  describe 'ユーザ新規登録' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'urlは正しいか' do
        expect(current_path).to eq '/users/sign_up'
      end
      it 'nameフォームがあるか' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームがあるか' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームがあるか' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームがあるか' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '新規会員登録ボタンがあるか' do
        expect(page).to have_button '新規会員登録'
      end
    end

    context '新規登録成功時のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく登録されるか' do
        expect{ click_button '新規会員登録' }.to change(User.all, :count).by(1)
      end
      it '遷移先がトップページになっているか' do
        click_button '新規会員登録'
        expect(current_path).to eq '/'
      end
    end
  end

  describe 'ユーザーログインのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'urlは正しいか' do
        expect(current_path).to eq '/users/sign_in'
      end
      it 'passwordフォームはあるか' do
        expect(page).to have_field 'user[password]'
      end
      it 'Log inボタンがあるか' do
        expect(page).to have_button 'ログイン'
      end
    end
    context 'ログイン時のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it '遷移後がトップページになっているか' do
        expect(current_path).to eq '/'
      end
    end
    context 'ログイン失敗時のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe 'ヘッダーのテスト（ログイン後）' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示の確認' do
      it 'ロゴのリンクはあるか' do
        logo_link = find_all('a')[0].native.inner_text
        expect(logo_link).to match("")
      end
      it 'マイページのリンクがあるか' do
        my_page_link = find_all('a')[1].native.inner_text
        expect(my_page_link).to match(/マイページ/i)
      end
      it '概要のリンクがあるか' do
        about_link = find_all('a')[2].native.inner_text
        expect(about_link).to match(/概要/i)
      end
      it '神社のリンクがあるか' do
        shrine_link = find_all('a')[3].native.inner_text
        expect(shrine_link).to match(/神社/i)
      end
      it 'ログアウトのリンクがあるか' do
        logout_link = find_all('a')[59].native.inner_text
        expect(logout_link).to match(/ログアウト/i)
      end
    end

    context 'リンクの遷移先が正しいか' do
      subject { current_path }

      it 'ロゴのリンクは正しいか' do
        logo_link = find_all('a')[0].native.inner_text
        click_link logo_link, match: :first
        is_expected.to eq '/'
      end
      it 'マイページのリンクは正しいか' do
        my_page_link = find_all('a')[1].native.inner_text
        click_link my_page_link, match: :first
        is_expected.to eq '/users/' + user.id.to_s
      end
      it '概要のリンクは正しいか' do
        about_link = find_all('a')[2].native.inner_text
        click_link about_link
        is_expected.to eq '/home/about'
      end
      it '神社のリンクはあるか' do
        shrine_link = find_all('a')[3].native.inner_text
        click_link shrine_link
        is_expected.to eq '/shrines'
      end
      it 'ログアウトのリンクは正しいか' do
        logout_link = find_all('a')[59].native.inner_text
        click_link logout_link
        is_expected.to eq '/users/sign_out'
      end
    end
  end
end