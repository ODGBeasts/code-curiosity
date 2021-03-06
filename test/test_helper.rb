# require "codeclimate-test-reporter"
require 'sidekiq/testing'
# CodeClimate::TestReporter.start

require 'simplecov'


ENV["RAILS_ENV"] = "test"

SimpleCov.start 'rails'

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "webmock/minitest"
require "mocha/minitest"
require "stripe_mock"

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"
# require 'capybara/poltergeist'

# Uncomment for awesome colorful output
#require "minitest/pride"

# Mongoid adapter for DatabaseCleaner
require 'database_cleaner/mongoid'

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_hosts 'codeclimate.com'
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include Warden::Test::Helpers
  include ActiveJob::TestHelper
  WebMock.disable_net_connect!(allow: "codeclimate.com")
  before { StripeMock.start }
  after { StripeMock.stop }

  def stub_get(path, endpoint = Github.endpoint.to_s)
    stub_request(:get, endpoint + path)
  end
end

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  include FactoryBot::Syntax::Methods
  WebMock.disable_net_connect!(allow: "codeclimate.com")
  DatabaseCleaner.strategy = :truncation
  before do
    DatabaseCleaner.start
    StripeMock.start
  end

  after do
    # DatabaseCleaner.clean
    StripeMock.stop
  end
end

# class ActionDispatch::IntegrationTest
#   include Warden::Test::Helpers
#   include Rails.application.routes.url_helpers
#   include Capybara::DSL
#   Capybara.current_driver = :poltergeist
#   Capybara.register_driver :poltergeist do |app|
#     Capybara::Poltergeist::Driver.new(app, timeout: 1.minute, phantomjs_options: ['--load-images=no'])
#   end
#   WebMock.allow_net_connect!(allow: "codeclimate.com")
#   before { StripeMock.start }
#   after { StripeMock.stop }
# end

# class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
#   driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
# end
