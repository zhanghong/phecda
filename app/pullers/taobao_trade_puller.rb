# encoding : utf-8 -*-
class TaobaoTradePuller
  def self.create_by_tid(shop, tid)
    begin
      response = TaobaoQuery.get({
        method: 'taobao.trade.fullinfo.get', tid: tid,
        fields: 'total_fee, created, tid, status, post_fee, receiver_name, pay_time, end_time, receiver_state, receiver_city, receiver_district, receiver_address, receiver_zip, receiver_mobile, receiver_phone, buyer_nick, tile, type, point_fee, is_lgtype, is_brand_sale, is_force_wlb, modified, alipay_id, alipay_no, alipay_url, shipping_type, buyer_obtain_point_fee, cod_fee, cod_status, commission_fee, seller_nick, consign_time, received_payment, payment, timeout_action_time, has_buyer_message, real_point_fee, orders',
        }, shop.id)

      trade = response['trade_fullinfo_get_response']['trade']
      orders = trade.delete('orders')
      trade = Tb::Trade.new(trade)
      trade.shop_id = shop.id

      order.each do |o|
        taobao_order = trade.tb_orders.build(o)
      end
      trade.save
    end
  end

  def self.update_by_tid(shop, tid)
    begin
      response = TaobaoQuery.get({
        method: 'taobao.trade.fullinfo.get', tid: tid,
        fields: 'total_fee, created, tid, status, post_fee, receiver_name, pay_time, end_time, receiver_state, receiver_city, receiver_district, receiver_address, receiver_zip, receiver_mobile, receiver_phone, buyer_nick, tile, type, point_fee, is_lgtype, is_brand_sale, is_force_wlb, modified, alipay_id, alipay_no, alipay_url, shipping_type, buyer_obtain_point_fee, cod_fee, cod_status, commission_fee, seller_nick, consign_time, received_payment, payment, timeout_action_time, has_buyer_message, real_point_fee, orders',
        }, shop.id)

      trade = response['trade_fullinfo_get_response']['trade']
      orders = trade.delete('orders')
      trade = Tb::Trade.find_by_tid(trade["tid"])
      trade.update(trade)

      order.each do |o|
        tb_order = trade.tb_orders.find_by_oid(o["oid"])
        tb_order.update(o)
      end
    end
  end
end
