class Post < ApplicationRecord
  belongs_to :user
  belongs_to :shrine
  has_many :post_images, dependent: :destroy
  accepts_attachments_for :post_images, attachment: :image

  validates :body, presence: true
  validates :visit_date, presence: true
  validate :not_future_visit_date

  def not_future_visit_date
    if visit_date.present? && visit_date > Date.today
      errors.add(:visit_date, "に未来の日付は使用できません")
    end
  end

end
