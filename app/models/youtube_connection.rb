class YoutubeConnection < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: true

  def store_tokens!(tokens)
    self.encrypted_tokens = encryptor.encrypt_and_sign(tokens.slice('access_token', 'refresh_token').to_json)
    self.expires_at = Time.current + tokens.fetch('expires_in', 3600).to_i.seconds
    save!
  end

  def access_token
    with_lock do
      tokens = JSON.parse(encryptor.decrypt_and_verify(encrypted_tokens))
      if expires_at <= 1.minute.from_now
        refreshed = YoutubeApi.token_request(grant_type: 'refresh_token', refresh_token: tokens.fetch('refresh_token'))
        tokens.merge!(refreshed)
        store_tokens!(tokens)
      end
      tokens.fetch('access_token')
    end
  rescue ActiveSupport::MessageEncryptor::InvalidMessage, JSON::ParserError, KeyError
    raise YoutubeApi::Error, 'Your YouTube connection could not be read. Please reconnect.'
  end

  private

  def encryptor
    key = Rails.application.key_generator.generate_key('niho-youtube-oauth-v1', 32)
    ActiveSupport::MessageEncryptor.new(key, cipher: 'aes-256-gcm')
  end
end
