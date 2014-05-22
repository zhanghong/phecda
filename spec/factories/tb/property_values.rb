# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tb_property_value, class: Tb::PropertyValue do
    association :shop, factory: :tb_shop
    association :property, factory: :tb_property
    name "70"
  end
end
