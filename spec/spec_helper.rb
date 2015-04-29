ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../spec/dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'pry-nav'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
