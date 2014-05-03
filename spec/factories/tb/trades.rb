# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tb_trade, :class => 'Tb::Trade' do
    association :shop, factory: :tb_shop
    tid "609496759312345"
    status "WAIT_BUYER_PAY"
  end
end
