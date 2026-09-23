class VideoGenre < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :video_genre, optional: true
  belongs_to :channel, optional: true
  has_many :sub_genres, class_name: 'VideoGenre', foreign_key: :video_genre_id, dependent: :destroy
  has_many :video_lessons, dependent: :destroy
  scope :ordered, -> { order(:sort, :title, :id) }
  validates :title, presence: true, length: { maximum: 200 }
  validates :sort, numericality: { only_integer: true }
  validate :valid_parent

  def self.visible_to(user)
    available = where(channel_id: [nil, user.comp&.channel_id], hide_flg: false)
    roots = available.where(video_genre_id: nil).select(:id)
    available.where(video_genre_id: nil).or(available.where(video_genre_id: roots))
  end

  def label
    [video_genre&.title, title].compact.join(' / ')
  end

  private

  def valid_parent
    return unless video_genre
    if video_genre_id == id || video_genre.video_genre_id.present? || sub_genres.exists?
      errors.add(:video_genre, 'must be a top-level category; only one subtitle level is supported')
    end
    errors.add(:video_genre, 'must belong to the same channel') unless video_genre.channel_id == channel_id
  end
end
