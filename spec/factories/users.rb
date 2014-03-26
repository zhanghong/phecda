# encoding: utf-8
# http://rubyer.me/blog/1460/
FactoryGirl.define do
	factory :user do
		name "admin"
		mobile "13212345678"
		email "admin@test.com"
		password "12345678"
		role "super_admin"
		sign_in_count 0
	end
end