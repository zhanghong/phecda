# encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :core_stock, :class => 'Core::Stock' do
    association :account
    association :updater
    association :deleter

    factory :stock_default do
      name "默认仓库"
    end
  end
end
