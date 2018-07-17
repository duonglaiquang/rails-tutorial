class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_by_created_at, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.content_max}
  validate :picture_size

  private

  def picture_size
    return if picture.size <= Settings.micropost.picture_size.megabytes
      errors.add(:picture, t("microposts.picture_size_error",
        size: Settings.micropost.picture_size).html_safe)
  end
end
