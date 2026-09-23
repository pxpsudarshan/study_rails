require 'faraday'
require 'json'
require 'uri'
require 'erb'

class YoutubeApi
  SCOPE = 'https://www.googleapis.com/auth/youtube.force-ssl'.freeze
  class Error < StandardError; end

  def self.setting(name)
    ENV["YOUTUBE_#{name.to_s.upcase}"].presence || Rails.application.credentials.dig(:youtube, name)
  end

  def self.redirect_uri
    setting(:redirect_uri).presence || ('http://localhost:3000/youtube/callback' if Rails.env.development?)
  end

  def self.configured?
    setting(:client_id).present? && setting(:client_secret).present? && redirect_uri.present?
  end

  def self.authorization_url(state)
    raise Error, 'YouTube credentials have not been configured on this server.' unless configured?
    'https://accounts.google.com/o/oauth2/v2/auth?' + URI.encode_www_form(
      client_id: setting(:client_id), redirect_uri: redirect_uri, response_type: 'code',
      scope: SCOPE, state: state, access_type: 'offline', prompt: 'consent'
    )
  end

  def self.exchange(code)
    tokens = token_request(code: code, redirect_uri: redirect_uri, grant_type: 'authorization_code')
    unless tokens['scope'].to_s.split.include?(SCOPE) && tokens['refresh_token'].present?
      raise Error, 'Caption permission was not granted. Connect again and allow the requested YouTube permission.'
    end
    tokens
  end

  def self.token_request(parameters)
    response = http('https://oauth2.googleapis.com').post('/token', parameters.merge(
      client_id: setting(:client_id), client_secret: setting(:client_secret)))
    raise Error, 'Google authorization failed or expired. Please reconnect YouTube.' unless response.success?
    result = JSON.parse(response.body)
    raise Error, 'Google returned an invalid authorization response.' if result['access_token'].blank?
    result
  rescue Faraday::Error, JSON::ParserError
    raise Error, 'Could not connect to Google. Please try again.'
  end

  def self.http(url)
    Faraday.new(url: url) do |connection|
      connection.request :url_encoded
      connection.options.timeout = 20
      connection.options.open_timeout = 5
      connection.adapter Faraday.default_adapter
    end
  end

  def initialize(connection)
    @connection = connection
    raise Error, 'Connect your YouTube account first.' unless connection
  end

  def tracks(video_id)
    data = JSON.parse(get('/youtube/v3/captions', part: 'snippet', videoId: video_id))
    data.fetch('items', []).reject { |track| track.dig('snippet', 'status') == 'failed' }
  rescue JSON::ParserError
    raise Error, 'YouTube returned an invalid caption list. Please try again.'
  end

  def download(video_id, track_id)
    track = tracks(video_id).find { |item| item['id'] == track_id }
    raise Error, 'Select a caption track belonging to this video.' unless track
    SubtitleParser.parse(get("/youtube/v3/captions/#{ERB::Util.url_encode(track_id)}", tfmt: 'vtt'), skip_non_displayable: true)
  end

  private

  def get(path, params)
    response = self.class.http('https://www.googleapis.com').get(path, params) do |request|
      request.headers['Authorization'] = "Bearer #{@connection.access_token}"
    end
    unless response.success?
      message = case response.status
      when 401 then 'Your YouTube connection has expired. Please reconnect.'
      when 403 then 'YouTube denied access. Check that this account owns the video, the API is enabled, and quota is available.'
      when 404 then 'The video or subtitle track was not found on YouTube.'
      else 'YouTube is temporarily unavailable. Please try again.'
      end
      raise Error, message
    end
    response.body
  rescue Faraday::Error
    raise Error, 'Could not connect to YouTube. Please try again.'
  end
end
