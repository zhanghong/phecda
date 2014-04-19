# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :brandy_sku_1_weight_70, class: Tb::SkuProperty do
    association :sku, factory: :brandy_product_1_sku_1
    association :property_value, factory: :brandy_weight_70
  end

  factory :brandy_sku_2_weight_150, class: Tb::SkuProperty do
    association :sku, factory: :brandy_product_1_sku_2
    association :property_value, factory: :brandy_weight_150
  end
end
