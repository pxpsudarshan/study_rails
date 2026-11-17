#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../test/simplecov_env"

SimpleCovEnv.configure_profile
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::SimpleFormatter,
  SimpleCov::Formatter::CoberturaFormatter
])

resultset_files = Dir.glob(File.join("coverage", "*", ".resultset.json"))
if resultset_files.empty?
  puts "No coverage resultsets found to collate."
  exit 0
end

puts "Collating coverage from: #{resultset_files.join(', ')}"

SimpleCov.collate(resultset_files) do
  coverage_dir "coverage"
end
