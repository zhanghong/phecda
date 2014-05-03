# encoding: utf-8
require 'spec_helper'

describe TaobaoTradePuller do
  before do
    @tb_app_token = create(:tb_app_token)
    @shop = @tb_app_token.shop
  end

  context "同步一个新的淘宝订单" do
    it "同步一个新的淘宝订单" do
      excon_mock_with("tb_trades/pay_detail.json")
      TaobaoTradePuller.create_by_tid(@shop, "609496759312345")

      trade = Tb::Trade.find_by_tid("609496759312345")

      trade.should_not  be_nil
      trade.alipay_id.should  eq("20880023045312344")
      trade.alipay_no.should  eq("2014041011001001710054812345")
      trade.buyer_nick.should eq("测试buyer")
      trade.created.should    eq(Time.parse("2014-05-02 19:30:13"))
      trade.modified.should   eq(Time.parse("2014-05-02 19:33:09"))
      trade.cod_fee.should    eq(0.0)
      trade.status.should     eq("WAIT_SELLER_SEND_GOODS")
      trade.total_fee.should  eq(15.5)
      trade.payment.should    eq(15.5)

      trade.orders.size.should  eq(1)
      order = trade.orders.first
      order.oid.should        eq("637474996112971")
      order.num_iid.should    eq("38887090523")
      order.outer_iid.should  eq("120460000")
      order.cid.should        eq("50021623")

      order.price.should      eq(15.5)
      order.discount_fee.should   eq(15.5)
      order.adjust_fee.should eq(0.0)
      order.total_fee.should  eq(15.5)
    end
  end

  context "更新已有淘宝订单" do
    it "更新一个淘宝订单" do
      tb_order = create(:tb_order)
      tb_trade = tb_order.trade
      tb_trade.tid.should     eq("609496759312345")

      excon_mock_with("tb_trades/pay_detail.json")
      TaobaoTradePuller.update_by_tid(@shop, "609496759312345")

      Tb::Trade.count.should  eq(1)
      trade = Tb::Trade.find_by_tid("609496759312345")
      trade.alipay_id.should  eq("20880023045312344")
      trade.alipay_no.should  eq("2014041011001001710054812345")
      trade.buyer_nick.should eq("测试buyer")
      trade.created.should    eq(Time.parse("2014-05-02 19:30:13"))
      trade.modified.should   eq(Time.parse("2014-05-02 19:33:09"))
      trade.cod_fee.should    eq(0.0)
      trade.status.should     eq("WAIT_SELLER_SEND_GOODS")
      trade.total_fee.should  eq(15.5)
      trade.payment.should    eq(15.5)

      trade.orders.size.should  eq(1)
      Tb::Order.count.should  eq(1)
      order = trade.orders.first
      order.oid.should        eq("637474996112971")
      order.num_iid.should    eq("38887090523")
      order.outer_iid.should  eq("120460000")
      order.cid.should        eq("50021623")
      order.status.should     eq("WAIT_SELLER_SEND_GOODS")
      order.price.should      eq(15.5)
      order.discount_fee.should   eq(15.5)
      order.adjust_fee.should eq(0.0)
      order.total_fee.should  eq(15.5)
    end
  end
end
