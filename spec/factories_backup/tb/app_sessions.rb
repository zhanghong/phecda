# encoding: utf-8
FactoryGirl.define do
	factory Tb::AppSession do
		association :shop
		nick "sandbox_zhanghong"
    app_key "1021670514"
    app_secret	"sandboxcfb450954a95d9f6b48ad4112"
    session_key "610142022bf5b6f035482efe95101737309cb8494295c243611765114"
	end
end