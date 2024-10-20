require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsTest
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"

    #config.autoload_lib(ignore: %w(assets tasks))
    config.autoload_paths << "#{Rails.root}/lib"
#    config.eager_load_paths << "#{Rails.root}/lib"

#    %w(assets tasks).each do |subdir|
#      Rails.autoloaders.main.ignore("#{Rails.root}/lib/#{subdir}")
#    end

    config.time_zone = 'Tokyo'
    config.active_record.time_zone_aware_attributes = false
    config.active_record.default_timezone = :local
    config.encoding = "utf-8"

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.templates.push("#{config.root}/generator_templates")
    end
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja
    config.generators.javascript_engine = :js
    require 'mobile_fu'
    require 'record_with_operator'
  end
end
