# encoding: utf-8
# frozen_string_literal: true

require 'chef'
require 'chefspec'
require 'chefspec/berkshelf'
require 'json'
require 'tempfile'
require 'simplecov'
require 'simplecov-console'
require 'coveralls'

RSpec.configure do |c|
  c.color = true
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console
]
SimpleCov.minimum_coverage(100)
SimpleCov.start

at_exit { ChefSpec::Coverage.report! }
