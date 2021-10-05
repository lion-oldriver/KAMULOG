class ShrineImage < ApplicationRecord
  belongs_to :shrine
  attachment :image
end
