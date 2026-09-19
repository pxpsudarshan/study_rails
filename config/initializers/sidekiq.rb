Sidekiq.configure_server do |config|
  config.logger = Logger.new("log/sidekiq.log", 5, 10 * 1024 * 1024)
  config.logger.level = Logger::DEBUG
  config.logger.formatter = Sidekiq::Logger::Formatters::JSON.new
end
