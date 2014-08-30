source "http://ruby.taobao.org"

require "cgi"
gem "rails", "4.0.1"
gem "mysql2"
gem "sass-rails", "~> 4.0.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.0"
gem "jquery-rails"
gem "turbolinks"
gem "jquery-turbolinks"
gem "jbuilder", "~> 1.2"
gem "json"
gem "crack"
gem "excon"
gem "omniauth"
gem "omniauth-oauth2"
gem "taobao_fu_reload", "~> 1.1.2"
gem "simple_form"
gem "devise"
gem "cancan"
gem "awesome_nested_set"
gem "rails-settings-cached", "0.3.1"
gem "thin"
gem "anjlab-bootstrap-rails", :require => "bootstrap-rails",
                              :github => "anjlab/bootstrap-rails"
gem "active_link_to"
gem "nprogress-rails"
gem "will_paginate"
gem "will_paginate-bootstrap"
gem "paperclip", "~> 3.0"
gem "state_machine", "~> 1.2.0"
gem "spreadsheet", "0.9.6"
gem "date_validator", "~> 0.7.0"
gem "sidekiq", "~> 2.13.0"
gem "sidekiq-unique-jobs", "~> 2.6.7"
gem "remotipart", "~> 1.2"
#http://fontawesome.io/icons/
gem "therubyracer"
gem "less-rails"
gem "font-awesome-less"
require "yaml"

group :doc do
 gem "sdoc", require: false
end

# group :development do
#   gem "rspec-rails"
# end

group :development do
  gem 'guard-rspec', '~> 3.0.2'
  gem 'guard-spork', '~> 1.5.1'
  gem 'spork-rails', github: 'sporkrb/spork-rails'
  gem 'rb-fsevent', '~> 0.9.3'
end

group :development, :test do
  gem "rspec-rails", "~> 2.14.0"
  gem "factory_girl_rails", "~> 4.2.1"
end

group :test do
  gem "faker", "~> 1.1.2"
  gem "capybara", "~> 2.1.0"
  gem "database_cleaner", "~> 1.0.1"
  gem "launchy", "~> 2.3.0"
  gem "shoulda-matchers", "~> 2.2.0"
  gem "selenium-webdriver", "~> 2.35.1"
end

# group :test do
#   # http://railsapps.github.io/tutorial-rails-devise-rspec-cucumber.html
#   #Capybara
#   gem "rspec-rails"
#   gem "factory_girl_rails", "~> 4.4.1"
#   gem "capybara"
#   gem "database_cleaner"
#   gem "email_spec"
#   gem "shoulda-matchers"
#   # gem "cucumber-rails", :require => false
#   #gem "mocha"
#   #gem "rcov"
# end