# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tb_sku_property, class: Tb::SkuProperty do
    association :sku, factory: :tb_sku
    association :property_value, factory: :tb_property_value
  end
end
