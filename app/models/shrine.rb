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

  geocoded_by :address
  after_validation :geocode

  def save_tag(sent_tags)
    current_tags = tags.pluck(:tag_name) unless tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags
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
