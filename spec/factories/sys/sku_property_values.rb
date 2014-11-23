# encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :sys_sku_property_value, :class => "Sys::SkuPropertyValue" do
    association :sku
    association :property_value
    association :account
    association :updater
    association :deleter
  end
end