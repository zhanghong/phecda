# encoding: utf-8
FactoryGirl.define do
	factory :account, class: Account do
    phone "18512345678"
    email { Faker::Internet.email }

    factory :brandy_account do
      name "brandy"
    end
	end
end