# encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :sys_property_values, :class => "Sys::PropertyValue" do
    association :property
    association :account
    association :updater
    association :deleter
    name       "Sys 属性值"
  end
end