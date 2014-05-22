# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tb_category, class: Tb::Category do
    name "cat_1"
    cid  "849445619"
    association :shop, factory: :tb_shop
  end
end
