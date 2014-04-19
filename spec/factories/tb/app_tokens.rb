# encoding: utf-8
FactoryGirl.define do
  factory :tb_app_token, class: Tb::AppToken do
    association :shop, factory: :tb_shop
    app_id 1
    nick "brandy_store_token"
    user_id "00001001"
    refresh_token "6201d120ef657a9d5821ZZdb86c761a40403cf9df3c7ed33611765114"
    access_token "6201812248f169ed571bdf63fb35bf11293ab41f455d7ca3611765114"
  end
end