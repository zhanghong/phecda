# encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :sys_product, :class => "Sys::Product" do
    association :category
    association :account
    association :updater
    association :deleter
    title       "Sys 商品标题"
    num 10
    description "商品描述……"
    price   99.90
  end
end