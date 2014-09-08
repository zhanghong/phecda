# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :core_seller_area, :class => 'Core::SellerArea' do
    association :account
    association :seller
    association :area
    association :updater
  end
end
