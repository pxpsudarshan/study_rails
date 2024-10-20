require 'faraday'

module AzureApi
  class HttpErrorHandler < Faraday::Middleware
    def on_complete(env)
      return if [200, 302, 404].include?(env[:status])
      case env[:status]
      when 401
        raise AzureApiAuthError.new(env)
      else
        p JSON.parse(env.body)
        raise AzureResponseError.new(env)
      end
    end
  end
end

class AzureApiAuthError < StandardError
  attr_accessor :env

  def initialize(env)
    @env = env
  end
end

class AzureResponseError < StandardError
  attr_accessor :env

  def initialize(env)
    @env = env
    super(env)
  end
end
