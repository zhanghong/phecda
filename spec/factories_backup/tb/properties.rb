# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :brandy_property_1, class: Tb::Property do
    association :shop, factory: :brandy_store
    name "weight"
  end
end
