# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory Sys::Property do
  	association :account
		name "属性_1"
  end
end
