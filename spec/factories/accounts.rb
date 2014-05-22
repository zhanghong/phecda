# encoding: utf-8
FactoryGirl.define do
  # sequence :email do |n|
  #   "account#{n}@test.com"
  # end

	factory :account, class: Account do
		name "Brandy"
    email "brandy@test.com"
    phone "18512345678"
	end
end