# encoding: utf-8
FactoryGirl.define do
  # sequence :email do |n|
  #   "account#{n}@test.com"
  # end

	factory :brandy, class: Account do
		name "Brandy"
    email "brandy@test.com"
    phone "18512345678"
	end

  factory :vbox, class: Account do
    name "Vbox"
    email "vbox@test.com"
    phone "13012345678"
  end
end