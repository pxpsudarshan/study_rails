require 'faraday'

module AzureApi
  class Base

    def initialize(azure)
      @azure = azure
      @connection = build_connection
    end

    def check_azure_auth
      response = get('/cognitiveservices/voices/list', {})
      JSON.parse(response.body)
    end

    def send_request(params = {})
      params = {
        speak_lang: 'ja-JP',
        voice_lang: 'ja-JP',
        voice_gender: 'Female',
        voice_name: 'ja-JP-NanamiNeural',
        text: 'はじめまして、田中です。よろしくお願いします。',
        filename: 'test'
      } if params.blank?
      payload = "
        <speak version='1.0' xml:lang='#{params[:speak_lang]}'>
          <voice 
            xml:lang='#{params[:voice_lang]}' 
            xml:gender='#{params[:voice_gender]}' 
            name='#{params[:voice_name]}'>#{params[:text]}
          </voice>
        </speak>"
      result = post('/cognitiveservices/v1', payload)
      p = File.open(Rails.root.join("tmp/#{params[:filename]}.mp3"),'wb')
      p.write(result.body)
      p.close unless p.nil?
    end

    private

    def post(url, payload)
      @connection.post do |req|
        req.url url
        req.headers['Content-Type'] = 'application/ssml+xml'
        req.headers['Host'] = 'japaneast.tts.speech.microsoft.com'
        req.headers['Content-Length'] = payload.length.to_s
        req.headers['User-Agent'] =  'Niho'
        req.headers['X-Microsoft-OutputFormat'] = 'audio-48khz-192kbitrate-mono-mp3'
        req.body = payload
      end
    end

    def get(url, params)
      @connection.get do |request|
        request.url url
        request.headers['Host'] = 'japaneast.tts.speech.microsoft.com'
        request.params = params
      end
    end

    def build_connection
      Faraday.new(url: build_host_url, headers: build_header) do |faraday|
        faraday.adapter :net_http
        faraday.request :url_encoded
        faraday.use HttpErrorHandler
      end
    end

    def build_host_url
      "#{@azure.subdomain}"
    end

    def build_header
      { 'Ocp-Apim-Subscription-Key' => @azure.access_key }
    end
  end
end
