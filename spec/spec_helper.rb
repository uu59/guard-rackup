require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :test)

ENV["GUARD_ENV"] = 'test'

Dir["#{File.expand_path('..', __FILE__)}/support/**/*.rb"].each { |f| require f }

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start
end
require 'guard/rackup'

RSpec.configure do |conf|
end
