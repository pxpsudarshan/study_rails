require 'minitest/autorun'
require 'minitest/mock'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/numeric/bytes'
require 'action_controller'
require_relative '../../app/services/subtitle_parser'
require_relative '../../app/services/youtube_api'

class YoutubeApiTest < Minitest::Test
  Response = Struct.new(:status, :body) do
    def success?; status.between?(200, 299); end
  end

  class FakeHttp
    attr_reader :requests
    def initialize(responses)
      @responses, @requests = responses, []
    end
    def get(path, params)
      request = Struct.new(:headers).new({})
      yield request
      @requests << [path, params, request.headers]
      @responses.shift
    end
  end

  def setup
    @api = YoutubeApi.new(Struct.new(:access_token).new('fake-access-token'))
    @list = Response.new(200, { items: [{ id: 'caption-1', snippet: { language: 'ja', status: 'serving' } }] }.to_json)
  end

  def test_download_checks_video_track_membership_and_parses_vtt
    http = FakeHttp.new([@list, Response.new(200, "WEBVTT\n\n00:00.000 --> 00:01.000\n\n00:01.000 --> 00:02.000\nこんにちは\n")])
    YoutubeApi.stub(:http, http) do
      cues = @api.download('M7lc1UVf-VE', 'caption-1')
      assert_equal 'こんにちは', cues.first['text']
      assert_equal 'M7lc1UVf-VE', http.requests.first[1][:videoId]
      assert_equal 'vtt', http.requests.last[1][:tfmt]
      assert_equal 'Bearer fake-access-token', http.requests.last[2]['Authorization']
    end
  end

  def test_rejects_a_track_from_a_different_video_before_downloading
    http = FakeHttp.new([@list])
    YoutubeApi.stub(:http, http) do
      assert_raises(YoutubeApi::Error) { @api.download('M7lc1UVf-VE', 'other-track') }
      assert_equal 1, http.requests.length
    end
  end

  def test_denied_api_response_does_not_expose_provider_body
    http = FakeHttp.new([Response.new(403, 'sensitive provider details')])
    YoutubeApi.stub(:http, http) do
      error = assert_raises(YoutubeApi::Error) { @api.tracks('M7lc1UVf-VE') }
      refute_includes error.message, 'sensitive'
      assert_includes error.message, 'denied'
    end
  end

  def test_exchange_requires_caption_permission_and_refresh_token
    [{ 'access_token' => 'a', 'scope' => 'openid', 'refresh_token' => 'r' },
     { 'access_token' => 'a', 'scope' => YoutubeApi::SCOPE }].each do |tokens|
      YoutubeApi.stub(:redirect_uri, 'http://localhost:3000/youtube/callback') do
        YoutubeApi.stub(:token_request, tokens) do
          assert_raises(YoutubeApi::Error) { YoutubeApi.exchange('fake-code') }
        end
      end
    end
  end
end
