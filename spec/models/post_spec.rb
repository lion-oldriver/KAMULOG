require 'rails_helper'

RSpec.describe 'postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post.valid? }

    let(:user) { create(:user) }
    let(:shrine) { create(:shrine) }
    let!(:post) { build(:post, user_id: user.id, shrine_id: shrine.id) }

    context 'bodyカラム' do
      it '空欄でないこと' do
        post.body = ''
        is_expected.to eq false
      end
    end

    context 'visit_dateカラム' do
      it '空欄でないこと' do
        post.visit_date = ''
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Shrineモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:shrine).macro).to eq :belongs_to
      end
    end
    context 'PostImageモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:post_images).macro).to eq :has_many
      end
    end
  end
end