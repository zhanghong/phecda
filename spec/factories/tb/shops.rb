# encoding: utf-8
FactoryGirl.define do
	factory :brandy_store, class: Tb::Shop do
		association :account, factory: :brandy
		nick "sandbox_zhanghong"
    user_id "54501437"
	end

  factory :brandy_flagship, class: Tb::Shop do
    association :account, factory: :brandy
    nick "sandbox_zhanghong"
    user_id "54501437"
  end

  factory :vbox_shop, :class => Tb::Shop do
    association :account, factory: :vbox
    nick "zhanghong_bean"
    user_id "54501437"
  end
end