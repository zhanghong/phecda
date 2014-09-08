# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :core_role, :class => 'Core::Role' do
    name "admin"
    association :account
    association :updater
    association :deleter
  end
end