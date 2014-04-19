# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :brandy_product_1_sku_1, class: Tb::Sku do
    association :shop, factory: :brandy_store
    association :product, factory: :brandy_product_1
  end

  factory :brandy_product_1_sku_2, class: Tb::Sku do
    association :shop, factory: :brandy_store
    association :product, factory: :brandy_product_1
  end
end
