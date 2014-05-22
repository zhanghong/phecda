# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tb_sku, class: Tb::Sku do
    association :shop, factory: :tb_shop
    association :product, factory: :tb_product
  end
end
