# encoding: utf-8
# http://rubyer.me/blog/1460/
FactoryGirl.define do
	factory :user do
		name { "test" + Faker::Name.first_name }
		mobile "13212345678"
    sequence(:email) { |n| "user_#{n}@phecda.com"}
		password "123456"
		sign_in_count 0

    factory :superadmin_user do
      name "superadmin"
      is_superadmin true
    end

    factory :updater do
      name "updater"
    end

    factory :deleter do
      name "deleter"
    end
	end
end