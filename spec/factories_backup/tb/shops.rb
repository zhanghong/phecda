# encoding: utf-8
FactoryGirl.define do
	factory :brandy_store, class: Tb::Shop do
		association :account, factory: :brandy
		nick "brandy_store_token"
    user_id "00001001"
	end

  factory :brandy_flagship, class: Tb::Shop do
    association :account, factory: :brandy
    nick "brandy_flagship_token"
    user_id "00001002"
  end

  factory :vbox_shop, :class => Tb::Shop do
    association :account, factory: :vbox
    nick "vbox_shop_token"
    user_id "00001003"
  end
end