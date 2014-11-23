# encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :sys_categories_properties, :class => "Sys::CategoryProperty" do
    association :category
    association :property
    association :account
    association :updater
    association :deleter
  end
end