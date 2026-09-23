require 'uri'

class VideoLesson < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :video_genre, optional: true
  belongs_to :channel, optional: true
  validates :sort, numericality: { only_integer: true }
  validate :publication_category

  def self.visible_to(user)
    where(hide_flg: false, channel_id: [nil, user.comp&.channel_id], video_genre_id: VideoGenre.visible_to(user).select(:id))
  end

  belongs_to :user
  attr_accessor :youtube_url, :subtitle_file
  before_validation :import_video, if: -> { !youtube_url.nil? }
  before_validation :import_subtitles, if: -> { subtitle_file.present? }
  before_validation :clear_caption_reference
  validates :title, presence: true, length: { maximum: 200 }
  validates :youtube_video_id, format: { with: /\A[A-Za-z0-9_-]{11}\z/, message: 'must be a valid YouTube video URL or ID' }
  validates :subtitle_cues, presence: { message: 'must be uploaded as an SRT or VTT file' }

  private

  def publication_category
    errors.add(:video_genre, 'is required before publishing') if !hide_flg && video_genre.nil?
    if video_genre && video_genre.channel_id != channel_id
      errors.add(:video_genre, 'must belong to the same channel')
    end
  end

  def clear_caption_reference
    self.youtube_caption_id = nil if persisted? && (will_save_change_to_youtube_video_id? || subtitle_file.present?)
  end

  def import_video
    value = youtube_url.strip
    if value.match?(/\A[A-Za-z0-9_-]{11}\z/)
      self.youtube_video_id = value
      return
    end
    uri = URI.parse(value)
    self.youtube_video_id = if %w[http https].include?(uri.scheme)
      case uri.host&.downcase
      when 'youtu.be' then uri.path.split('/')[1]
      when 'youtube.com', 'www.youtube.com', 'm.youtube.com', 'www.youtube-nocookie.com'
        if uri.path == '/watch'
          URI.decode_www_form(uri.query.to_s).to_h['v']
        elsif uri.path.match?(%r{\A/(embed|shorts|live)/})
          uri.path.split('/')[2]
        end
      end
    end
  rescue URI::InvalidURIError, ArgumentError
    self.youtube_video_id = nil
  end

  def import_subtitles
    self.subtitle_cues = SubtitleParser.parse(subtitle_file.read(SubtitleParser::MAX_BYTES + 1))
  rescue SubtitleParser::Invalid => e
    errors.add(:subtitle_file, e.message)
  ensure
    subtitle_file.rewind
  end
end
