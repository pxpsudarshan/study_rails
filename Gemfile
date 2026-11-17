source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.4"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1" , force_ruby_platform: true
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
#gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
#gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
#gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
#gem "jbuilder"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
#gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri ] #, require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem 'ruby-graphviz'
  gem "rails-mermaid_erd"

  gem "capistrano", "~> 3.17", require: false
  gem "capistrano-rails", "~> 1.6", require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"

  gem "simplecov", require: false
  gem "simplecov-cobertura", require: false
end

gem 'nokogiri', force_ruby_platform: true


# Use Sass to process CSS
gem "sassc-rails"

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'bootstrap', '~> 5.2.1'
gem 'devise'
gem 'devise-i18n'
gem 'font-awesome-sass', '~> 5.13.0'
gem 'kaminari', '~> 1.2'
gem 'acts_as_paranoid'
gem 'cocoon'
gem 'nprogress-rails'
gem 'select2-rails'
gem 'holidays'
gem 'whenever', require: false
gem 'rails_autolink'
gem 'active_storage_validations'

# Browser detection
gem 'browser', '~> 6.0'

# Notification of application errors
gem 'exception_notification'

gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
gem 'recaptcha'
gem 'creek'
gem 'faraday'
gem "chartkick"
gem 'stripe'

gem "sidekiq", "~> 7.3"
gem "bigdecimal"
gem "base64"
gem "mutex_m"
gem "connection_pool", "< 3.0"
