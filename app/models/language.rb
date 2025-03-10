class Language < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :langs, polymorphic: true

  has_one_attached :mpg, dependent: :destroy

  attribute :update_flg

  validates :language, presence: true
  validates :content, presence: true

  before_save :get_media, if:  -> { !self.skip_flg }
  after_save :clean_tmp_media

  attr_accessor :skip_flg

  def get_media
    filename = "#{self.langs_id}_#{self.language}"
    case self.language
    when 'EN'
      params = {
        speak_lang: 'en-US',
        voice_lang: 'en-US',
        voice_gender: self.male_flg ? 'Male' : 'Female',
        voice_name: self.male_flg ? 'en-US-AndrewNeural' : 'en-US-EmmaNeural',
        text: self.content,
        filename: filename
    }
    when 'RU'
      params = {
        speak_lang: 'ru-RU',
        voice_lang: 'ru-RU',
        voice_gender: self.male_flg ? 'Male' : 'Female',
        voice_name: self.male_flg ? 'ru-RU-DmitryNeural' : 'ru-RU-DariyaNeural',
        text: self.content,
        filename: filename
    }
    when 'ID'
      params = {
        speak_lang: 'id-ID',
        voice_lang: 'id-ID',
        voice_gender: self.male_flg ? 'Male' : 'Female',
        voice_name: self.male_flg ? 'id-ID-ArdiNeural' : 'id-ID-GadisNeural',
        text: self.content,
        filename: filename
    }
    when 'MM'
      params = {
        speak_lang: 'my-MM',
        voice_lang: 'my-MM',
        voice_gender: self.male_flg ? 'Male' : 'Female',
        voice_name: self.male_flg ? 'my-MM-ThihaNeural' : 'my-MM-NilarNeural',
        text: self.content,
        filename: filename
    }
    when 'BD'
      params = {
        speak_lang: 'bn-BD',
        voice_lang: 'bn-BD',
        voice_gender: self.male_flg ? 'Male' : 'Female',
        voice_name: self.male_flg ? 'bn-BD-PradeepNeural' : 'bn-BD-NabanitaNeural',
        text: self.content,
        filename: filename
    }
    when 'VN'
      params = {
        speak_lang: 'vi-VN',
        voice_lang: 'vi-VN',
        voice_gender: self.male_flg ? 'Male' : 'Female',
        voice_name: self.male_flg ? 'vi-VN-NamMinhNeural' : 'vi-VN-HoaiMyNeural',
        text: self.content,
        filename: filename
    }
    when 'NP'
      params = {
        speak_lang: 'ne-NP',
        voice_lang: 'ne-NP',
        voice_gender: self.male_flg ? 'Male' : 'Female',
        voice_name: self.male_flg ? 'ne-NP-SagarNeural' : 'ne-NP-HemkalaNeural',
        text: self.content,
        filename: filename
    }
    end
    if params.present? && (!self.mpg.attached? || self.update_flg)
      self.update_flg = false
      AzureApi::Base.new(Azure.first).send_request(params)
      file_path = Rails.root.join('tmp',"#{filename}.mp3")
      self.mpg.attach(io: File.open(file_path), filename: "azure_#{self.language}.mp3") if File.exist?(file_path)
    end
  end

  def clean_tmp_media
    filename = "#{self.langs_id}_#{self.language}.mp3"
    file_path = Rails.root.join('tmp', filename)
    File.delete(file_path) if File.exist?(file_path)
  end
end
