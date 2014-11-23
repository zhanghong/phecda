# encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :sys_category, :class => "Sys::Category" do
    parent_id   nil
    association :account
    association :updater
    association :deleter
    name  "Sys 商品分类"
  end
end