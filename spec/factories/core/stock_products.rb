# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :core_stock_product, :class => 'Core::StockProduct' do
    association :stock
    association :product
    association :sku
    association :account
    association :updater

    factory :deleted_core_stock_product do
      association :deleter
    end
  end
end
