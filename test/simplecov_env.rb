# frozen_string_literal: true

require "simplecov"
require "simplecov-cobertura"

module SimpleCovEnv
  def self.configure_profile
    SimpleCov.configure do
      load_profile "rails"
      enable_coverage :branch
      skip "/test/"
      skip "/config/"
    end
  end

  def self.configure_formatter
    if ENV["CI"]
      SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::SimpleFormatter,
        SimpleCov::Formatter::CoberturaFormatter
      ])
    end
  end

  def self.start!
    configure_profile
    configure_formatter

    is_system_test = caller_locations.any? { |loc| loc.path.include?("system") } ||
                     ARGV.any? { |arg| arg.include?("system") }
    default_name = is_system_test ? "SystemTests" : "Minitest"
    name = ENV.fetch("SIMPLECOV_COMMAND_NAME", default_name)

    SimpleCov.command_name name
    SimpleCov.coverage_dir "coverage/#{name}"
    SimpleCov.start
  end
end
