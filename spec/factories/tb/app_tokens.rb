# encoding: utf-8
FactoryGirl.define do
	factory Tb::AppToken do
		association :shop
		nick "sandbox_zhanghong"
		user_id "3611765114"
		refresh_token "6201d120ef657a9d5821ZZdb86c761a40403cf9df3c7ed33611765114"
    access_token "6201812248f169ed571bdf63fb35bf11293ab41f455d7ca3611765114"
	end
end