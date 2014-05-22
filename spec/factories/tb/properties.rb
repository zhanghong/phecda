# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tb_property, class: Tb::Property do
    association :shop, factory: :tb_shop
    name "weight"
  end
end
