require 'rails_helper'

RSpec.describe 'Shrineモデルのテスト', type: :model do
  describe 'バリデーションチェック' do
    subject { shrine.valid? }

    let!(:other_shrine) { create(:shrine) }
    let(:shrine) { build(:shrine) }

    context 'nameカラム' do
      it '名前は空でないか' do
        shrine.name = ''
        is_expected.to eq false
      end
      it '一意性があるかどうか' do
        shrine.name = other_shrine.name
        is_expected.to eq false
      end
    end

    context "addressカラム" do
      it '住所は空でないか' do
        shrine.address = ''
        is_expected.to eq false
      end
    end

    context 'introductionカラム' do
      it '本文は空でないか' do
        shrine.introduction = ''
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのチェック' do
    context 'postモデル' do
      it '1:Nの関係か' do
        expect(Shrine.reflect_on_association(:posts).macro).to eq :has_many
      end
    end

    context 'bookmarkモデル' do
      it '1:Nの関係か' do
        expect(Shrine.reflect_on_association(:bookmarks).macro).to eq :has_many
      end
    end

    context 'tagモデル' do
      it '1:Nの関係か' do
        expect(Shrine.reflect_on_association(:tags).macro).to eq :has_many
      end
    end

    context 'shrine_tagモデル' do
      it '1:Nの関係か' do
        expect(Shrine.reflect_on_association(:shrine_tags).macro).to eq :has_many
      end
    end

    context 'godモデル' do
      it '1:Nの関係か' do
        expect(Shrine.reflect_on_association(:gods).macro).to eq :has_many
      end
    end

    context 'shrine_godモデル' do
      it '1:Nの関係か' do
        expect(Shrine.reflect_on_association(:shrine_gods).macro).to eq :has_many
      end
    end
  end
end
