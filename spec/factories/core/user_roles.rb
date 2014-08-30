# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :core_user_role, :class => 'Core::UserRoles' do
    association :account
    association :user
    association :role
    association :updater
  end
end
