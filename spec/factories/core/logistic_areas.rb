# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :core_logistic_area, :class => 'Core::LogisticArea' do
    association :account
    association :logistic
    association :area
    association :updater
  end
end
