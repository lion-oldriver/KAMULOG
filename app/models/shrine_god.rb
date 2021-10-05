class ShrineGod < ApplicationRecord
  belongs_to :shrine
  belongs_to :god
  
  validates :shrine_id, presence: true
  validates :god_id, presence: true
end
