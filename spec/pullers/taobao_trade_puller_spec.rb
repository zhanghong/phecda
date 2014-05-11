# encoding: utf-8
require 'spec_helper'

def valid_trade_fullinfo(file_name)
  local_file_path = "tb_trades/local/#{file_name}"
  tid = File.basename(file_name, ".yml").split("_").last

  trade_infos = read_yaml(local_file_path)
  order_items = trade_infos.delete("orders")

  trades = Tb::Trade.where(shop_id: @shop.id, tid: tid)
  trades.count.should   eq(1)

  trade = trades.first
  trade_infos.each do |attr_name, value|
    #puts "trade_name: #{attr_name}"
    if tb_trade_time_attrs.include?(attr_name)
      value = Time.parse(value)
    end
    trade.send(attr_name).should   eq(value)
  end

  trade.orders.size.should  eq(order_items.size)
  order_items.each do |order_item|
    order = trade.orders.where(oid: order_item["oid"]).first
    order_item.each do |attr_name, value|
      #puts "order_name: #{attr_name}"
      if tb_order_time_attrs.include?(attr_name)
        value = Time.parse(value)
      end
      order.send(attr_name).should  eq(value)
    end
  end
end

def valid_list_page(item_file_names)
  ["has_sku_tc_642384977212123.yml", "no_sku_wbcg_640112743476108.yml"]
  item_file_names.each do |file_name|
    valid_trade_fullinfo(file_name)
  end
end

describe TaobaoTradePuller do
  before do
    @tb_app_token = create(:tb_app_token)
    @shop = @tb_app_token.shop
  end

  [
    {
      name: "SKU TRADE_CLOSED",
      file_name: "has_sku_tc_642384977212123.yml",
      order_ids: ["642384977212123"]
    },{
      name: "SKU TRADE_CLOSED_BY_TAOBAO",
      file_name: "has_sku_tcbt_642260272113567.yml",
      order_ids: ["642260272113567"]
    },{
      name: "SKU WAIT_BUYER_CONFIRM_GOODS",
      file_name: "has_sku_wbcg_642885207215890.yml",
      order_ids: ["642885207215890"]
    },{
      name: "SKU WAIT_BUYER_PAY",
      file_name: "has_sku_wbp_643477609826489.yml",
      order_ids: ["643477609836489", "643477609846489"]
    },{
      name: "SKU WAIT_SELLER_SEND_GOODS",
      file_name: "has_sku_wssg_643490400592123.yml",
      order_ids: ["642260272113567", "643477609846489"]
    },{
      name: "NO SKU WAIT_BUYER_CONFIRM_GOODS",
      file_name: "no_sku_wbcg_640112743476108.yml",
      order_ids: ["640112743476108"]
    },{
      name: "NO SKU WAIT_BUYER_PAY",
      file_name: "no_sku_wbp_640942570314092.yml",
      order_ids: ["640942570314092"]
    },{
      name: "NO SKU WAIT_SELLER_SEND_GOODS",
      file_name: "no_sku_wssg_639909797276123.yml",
      order_ids: ["639909797286123", "640942570314092"]
    },{
      name: "NO SKU WAIT_SELLER_SEND_GOODS",
      file_name: "no_sku_wssg_640111377323123.yml",
      order_ids: ["640111377323123"]
    }
  ].each do |pull_item|
    context "同步淘宝订单 #{pull_item[:name]}" do
      it "创建订单 #{pull_item[:name]}" do
        yml_file_name = pull_item[:file_name]
        tid = File.basename(yml_file_name, ".yml").split("_").last

        excon_mock_with("tb_trades/server/#{yml_file_name}")
        TaobaoTradePuller.refresh_trade(@shop, tid)

        valid_trade_fullinfo(yml_file_name)
      end

      it "更新淘宝订单 #{pull_item[:name]}" do
        yml_file_name = pull_item[:file_name]
        tid = File.basename(yml_file_name, ".yml").split("_").last
        tb_trade = Tb::Trade.new(tid: tid, shop_id: @shop.id)
        pull_item[:order_ids].each do |oid|
          tb_trade.orders << Tb::Order.new(oid: oid)
        end
        tb_trade.save.should  be_true
        tb_trade.orders.count.should  eq(pull_item[:order_ids].size)

        excon_mock_with("tb_trades/server/#{yml_file_name}")
        TaobaoTradePuller.refresh_trade(@shop, tid)
        valid_trade_fullinfo(yml_file_name)
      end
    end
  end

  context "按下单时间增量查询卖家已卖出的交易数据" do
    
    it "单次抓取" do
      Excon.defaults[:mock] = true
      sub_time

      start_modified = (Time.now - 1.month).beginning_of_day.to_s(:db)
      end_modified = Time.now.to_s(:db)
      1.upto(2) do |page_no|
        sold_params = {
          access_token: @tb_app_token.access_token,
          format: "json",
          v: "2.0",
          timestamp: Time.now.localtime.to_s(:db),
          method: 'taobao.trades.sold.increment.get',
          fields: TaobaoTradePuller.taobao_trade_get_fields,
          type: TaobaoTradePuller.sync_taobao_trade_type,
          start_modified: start_modified,
          end_modified: end_modified,
          page_no: 0,
          page_size: 100,
          use_has_next: true
        }
        
        yml_data = read_yaml("tb_trades/server/trades_sold_increment_page_#{page_no}.yml")
        Excon.stub({:query => sold_params.merge(page_no: page_no)}, {:body => yml_data.to_json, :status => 200})
      end
      TaobaoTradePuller.increment_get_sold(@shop)
      item_files = ["has_sku_tc_642384977212123.yml", "no_sku_wbcg_640112743476108.yml"]
      valid_list_page(item_files)
    end

    it "多次抓取" do
      Excon.defaults[:mock] = true
      sub_time

      start_modified = (Time.now - 1.month).beginning_of_day.to_s(:db)
      end_modified = Time.now.to_s(:db)
      1.upto(2) do |page_no|
        sold_params = {
          access_token: @tb_app_token.access_token,
          format: "json",
          v: "2.0",
          timestamp: Time.now.localtime.to_s(:db),
          method: 'taobao.trades.sold.increment.get',
          fields: TaobaoTradePuller.taobao_trade_get_fields,
          type: TaobaoTradePuller.sync_taobao_trade_type,
          start_modified: start_modified,
          end_modified: end_modified,
          page_no: page_no,
          page_size: 100,
          use_has_next: true
        }
        
        yml_data = read_yaml("tb_trades/server/trades_sold_increment_page_#{page_no}.yml")
        Excon.stub({:query => sold_params.merge(page_no: page_no)}, {:body => yml_data.to_json, :status => 200})
      end
      TaobaoTradePuller.increment_get_sold(@shop)
      TaobaoTradePuller.increment_get_sold(@shop)
      item_files = ["has_sku_tc_642384977212123.yml", "no_sku_wbcg_640112743476108.yml"]
      valid_list_page(item_files)
    end
  end
end