class Shrine < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :shrine_tags, dependent: :destroy
  has_many :tags, through: :shrine_tags
  has_many :shrine_gods, dependent: :destroy
  has_many :gods, through: :shrine_gods
  has_many :shrine_images, dependent: :destroy
  accepts_attachments_for :shrine_images, attachment: :image
  is_impressionable counter_cache: true

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :introduction, presence: true
  # 住所から緯度と経度を取得
  geocoded_by :address
  after_validation :geocode
  # 閲覧数の多い順に並べ替える
  scope :views, -> { order(impressions_count: :desc) }
  # 複数条件でOR検索
  def self.search_multi(content)
    where("name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags)
      .or(self.where("god_name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags))
      .or(self.where("tag_name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags))
  end
  # 絞り込み検索
  def self.search_refined(content)
    joins(:gods, :tags).where("name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags)
      .or(self.joins(:gods, :tags).where("god_name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags))
      .or(self.joins(:gods, :tags).where("tag_name LIKE ?", "%#{content}%").includes(:shrine_gods, :gods, :shrine_tags, :tags))
  end
  # ブックマーク数の多い順に並び替える
  def self.bookmarks
    Shrine.joins(:bookmarks).where(bookmarks: { shrine_id: self.ids} ).group(:shrine_id).order("count(*) desc")
  end
  # 投稿の多い順に並び替える
  def self.posts
    Shrine.joins(:posts).where(posts: { shrine_id: self.ids} ).group(:shrine_id).order("count(*) desc")
  end
  # タグ登録
  def save_tag(sent_tags)
    current_tags = tags.pluck(:tag_name) unless tags.nil?
    old_tags = current_tags - sent_tags # 現在のタグから入力されたタグを引いて消去するタグを抽出する
    new_tags = sent_tags - current_tags # 入力されたタグから現在のタグを引いて新しく登録するタグを抽出する
    old_tags.each do |old_tag|
      tags.delete Tag.find_by(tag_name: old_tag)
    end
    new_tags.each do |new_tag|
      new_shrine_tag = Tag.find_or_create_by(tag_name: new_tag)
      tags << new_shrine_tag
    end
  end

  def save_god(sent_gods)
    current_gods = gods.pluck(:god_name) unless gods.nil?
    old_gods = current_gods - sent_gods
    new_gods = sent_gods - current_gods
    old_gods.each do |old_god|
      gods.delete God.find_by(god_name: old_god)
    end
    new_gods.each do |new_god|
      new_shrine_god = God.find_or_create_by(god_name: new_god)
      gods << new_shrine_god
    end
  end
end
