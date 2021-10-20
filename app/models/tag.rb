class Tag < ApplicationRecord
  has_many :shrine_tags, dependent: :destroy
  has_many :shrine, through: :shrine_tags

  validates :tag_name, presence: true, uniqueness: true
end
