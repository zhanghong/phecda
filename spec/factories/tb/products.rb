# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tb_product, class: Tb::Product do
    association :shop, factory: :tb_shop
    association :category, factory: :tb_category
    num_iid "0000000001"
    title "测试商品-1"
  end
end
