# encoding: utf-8
FactoryGirl.define do
  factory :tb_shop, class: Tb::Shop do
    association :account
    nick "brandy_store"
    user_id "579846587"
  end
end