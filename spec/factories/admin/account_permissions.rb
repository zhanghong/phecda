# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_account_permission, :class => 'Admin::AccountPermission' do
    association :account
    association :permission
    association :updater

    factory :deleted_account_permission do
      association :deleter
      deleted_at Time.now
    end
  end
end
