# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :brandy_cat_1, class: Tb::Category do
    name "cat_1"
    association :shop, factory: :brandy_store
  end

  factory :brandy_cat_2, class: Tb::Category do
    name "cat_2"
    association :shop, factory: :brandy_store
  end
end
