# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :core_role_permission, :class => 'Core::RolePermission' do
    association :account
    association :role
    association :permission
    association :updater

    factory :deleted_core_role_permission do
      association :deleter
      # datetime {Time.now}
    end
  end
end
