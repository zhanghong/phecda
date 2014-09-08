# encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :core_seller, :class => 'Core::Seller' do
    association :account
    association :updater
    association :deleter
    association :stock
    email { Faker::Internet.email }
    parent_id nil

    factory :seller_bj do
      name "北京经销商"
      fullname "北京经销商"
      mobile "13012345678"
      phone "010-28914083"
    end

    factory :seller_sh do
      name "上海经销商"
      fullname "上海经销商"
      mobile "18112345667"
      phone "021-92848134"
    end
  end
end
