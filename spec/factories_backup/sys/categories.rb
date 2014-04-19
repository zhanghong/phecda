# encoding: utf-8
FactoryGirl.define do
	factory Sys::Category do
		association :account
		name "一级分类_1"
	end
end