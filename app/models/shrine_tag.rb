class ShrineTag < ApplicationRecord
  belongs_to :shrine
  belongs_to :tag
  
  validates :shrine_id, presence: true
  validates :tag_id, presence: true
end
