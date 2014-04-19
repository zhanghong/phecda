# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :brandy_weight_70, class: Tb::PropertyValue do
    association :shop, factory: :brandy_store
    association :property, factory: :brandy_property_1
    name "70"
  end

  factory :brandy_weight_150, class: Tb::PropertyValue do
    association :shop, factory: :brandy_store
    association :property, factory: :brandy_property_1
    name "150"
  end
end
