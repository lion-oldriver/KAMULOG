class God < ApplicationRecord
  has_many :shrine_gods, dependent: :destroy, foreign_key: 'god_id'
  has_many :shrine, through: :shrine_gods

  validates :god_name, presence: true, uniqueness: true
end
