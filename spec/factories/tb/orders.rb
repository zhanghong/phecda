# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tb_order, :class => 'Tb::Order' do
    association :trade, factory: :tb_trade
    oid "637474996112971"
    payment 15.5
    status "WAIT_BUYER_PAY"
  end
end
