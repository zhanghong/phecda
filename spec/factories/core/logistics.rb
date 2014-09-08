# encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :core_logistic, :class => 'Core::Logistic' do
    association :account
    association :updater
    association :deleter

    factory :logistic_ems do
      name "EMS"
      deleter_id 0
    end

    factory :logistic_yt do
      name "圆通"
      deleter_id 0
    end
  end
end
