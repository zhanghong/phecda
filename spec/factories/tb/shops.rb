# encoding: utf-8
FactoryGirl.define do
	factory Tb::Shop do
		association :account
		nick "sandbox_zhanghong"
	end
end