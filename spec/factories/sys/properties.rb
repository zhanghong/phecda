# encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :sys_property, :class => "Sys::Property" do
    association :account
    association :updater
    association :deleter
    name       "sys 属性名"
    # state "actived"
  end
end