# encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :sys_sku, :class => "Sys::Sku" do
    association :product
    association :account
    association :updater
    association :deleter
    name       "Sys 商品SKU"
    num 10
    price   99.90
  end
end