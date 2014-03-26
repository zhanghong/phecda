# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory Sys::PropertyValue do
  	association :account
  	association :property
		name "属性_1的值"
  end
end
