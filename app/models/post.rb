class Post < ApplicationRecord
  belongs_to :user
  belongs_to :shrine
  has_many :post_images, dependent: :destroy
  accepts_attachments_for :post_images, attachment: :image

  validates :body, presence: true
  validates :visit_date, presence: true
  validate :not_future_visit_date
  validate :max_post_images
  # 参拝日に未来の日付を使えないようにする
  def not_future_visit_date
    if visit_date.present? && visit_date > Date.today
      errors.add(:visit_date, "に未来の日付は使用できません")
    end
  end
  # 写真投稿時の枚数の制限
  def max_post_images
    if post_images_images.length > 6
      errors.add(:base, "写真は6枚までです")
    end
  end
end
