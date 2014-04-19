# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :brandy_product_1, class: Tb::Product do
    association :shop, factory: :brandy_store
    association :category, factory: :brandy_cat_1
    num_iid "0000000001"
    title "测试商品-1"
  end

  factory :brandy_product_2, class: Tb::Product do
    association :shop, factory: :brandy_store
    association :category, factory: :brandy_cat_2
    num_iid "0000000002"
    title "测试商品-2"
  end
end
