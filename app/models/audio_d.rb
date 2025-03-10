class AudioD < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :audio_c_content

  has_one_attached :mpg, dependent: :destroy

  has_many :languages, as: :langs, dependent: :destroy
  accepts_nested_attributes_for :languages, allow_destroy: true

  attribute :update_flg

  validates :content, presence: true

  before_save :get_media
  after_save :clean_tmp_media

  def get_media
    params = {
      speak_lang: 'ja-JP',
      voice_lang: 'ja-JP',
      voice_gender: self.customer_flg ? 'Female' : 'Male',
      voice_name: self.customer_flg ? 'ja-JP-NanamiNeural' : 'ja-JP-KeitaNeural',
      text: self.content,
      filename: self.audio_c_content_id
    }
    if !self.mpg.attached? || self.update_flg
      self.update_flg = false
      AzureApi::Base.new(Azure.first).send_request(params)
      self.mpg.attach(io: File.open(Rails.root.join('tmp',"#{self.audio_c_content_id}.mp3")), filename: "azure.mp3")
    end
  end

  def clean_tmp_media
    filename = "#{self.audio_c_content_id}.mp3"
    file_path = Rails.root.join('tmp', filename)
    File.delete(file_path) if File.exist?(file_path)
  end
end
