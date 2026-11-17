# frozen_string_literal: true

require "test_helper"

#class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
#  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
#end

Capybara.register_driver :custom_headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  chrome_bin = %w[/usr/bin/google-chrome /usr/bin/chromium-browser /usr/bin/chromium].find { |p| File.exist?(p) }
  options.binary = chrome_bin if chrome_bin

  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-setuid-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--disable-gpu")
  options.add_argument("--window-size=1400,1400")

  service_args = {}
  service_args[:path] = "/usr/bin/chromedriver" if File.exist?("/usr/bin/chromedriver")

  service = Selenium::WebDriver::Chrome::Service.new(**service_args)
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options, service: service)
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :custom_headless_chrome
end
