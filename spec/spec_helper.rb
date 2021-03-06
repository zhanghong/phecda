# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require "email_spec"
require 'rspec/autorun'

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

def tb_trade_time_attrs
  %w(created end_time modified consign_time pay_time)
end

def tb_order_time_attrs
  %w(consign_time)
end

def read_yaml(local_path)
  YAML::load_file(File.join(Rails.root, 'spec/mock_data', local_path))
end

def excon_mock_with(local_path)
  yml_data = read_yaml(local_path)
  Excon.defaults[:mock] = true
  Excon.stub({}, {:body => yml_data.to_json, :status => 200})

  # body = open(File.join(Rails.root, 'spec/mock_data', local_path)).read
  # Excon.defaults[:mock] = true
  # Excon.stub({}, {:body => body, :status => 200})
end

def sub_time
  now = Time.now.beginning_of_day
  Time.stub(:now) { now }
end