class Post < ApplicationRecord
  belongs_to :user
  belongs_to :shrine
  has_many :post_images, dependent: :destroy
  accepts_attachments_for :post_images, attachment: :image

  validates :body, presence: true
  validates :visit_date, presence: true
end
