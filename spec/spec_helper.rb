# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require "email_spec"
require 'rspec/autorun'
# require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.include FactoryGirl::Syntax::Methods
  config.fixture_path = "#{::Rails.root}/spec/factories"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)

  # config.before(:suite) do
  #   DatabaseCleaner.strategy = :truncation
  # end
  # config.before(:each) do
  #   # DatabaseCleaner.clean
  #   DatabaseCleaner.start
  # end
  # config.after(:each) do
  #   # DatabaseCleaner.clean
  # end
end

def spec_fixture(filename)
  # File.expand_path(File.join(File.dirname(__FILE__), "fixtures", filename))
  #File.expand_path(File.join(File.dirname(__FILE__), "fixtures", filename))
  "/Users/shawn/code/pico/public/mock_data/tb_item_with_skus.json"
end

def stub_http_response_with(filename)
  format = filename.split('.').last.intern
  data = File.read(spec_fixture(filename))
  http = Net::HTTP.new('localhost', 80)

  response = Net::HTTPOK.new("1.1", 200, "Content for you")
  response.stub(:body).and_return(data)
  http.stub(:request).and_return(response)

  http_request = HTTParty::Request.new(Net::HTTP::Get, '')
  http_request.stub(:get_response).and_return(response)
  http_request.stub(:format).and_return(format)

  HTTParty::Request.stub(:new).and_return(http_request)
  HTTParty.get.with(Settings.tb_base_url).and_return(http_request)

  # case format
  # when :xml
  #   ToHashParser.from_xml(data)
  # when :json
  #   JSON.parse(data)
  # else
  #   data
  # end
end

# def mock_get_json(file_name)
#   # puts "http://localhost:3101/mock_data/#{file_name}.json"
#   response = HTTParty.get("http://localhost:3101/mock_data/#{file_name}.json")
#   puts "-----------------"
#   puts response
#   puts "+++++++++++++++++++"
#   HTTParty.should_receive(:get).and_return("aaaaaa")
#   # format = filename.split('.').last.intern
#   # data = file_fixture(filename)

#   # response = Net::HTTPOK.new("1.1", 200, "Content for you")
#   # response.stub!(:body).and_return("aaaa")

#   # http_request = HTTParty::Request.new(Net::HTTP::Get, 'http://localhost:3101', :format => format)
#   # http_request.stub!(:perform_actual_request).and_return(response)

#   # HTTParty::Request.should_receive(:new).and_return(http_request)
# end