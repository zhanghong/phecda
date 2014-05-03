# encoding : utf-8 -*-
class TaobaoTradePuller
  class << self
    def create_by_tid(shop, tid)
      begin
        response = Tb::Query.get({
          method: 'taobao.trade.fullinfo.get', tid: tid,
          fields: taobao_trade_get_fields,
          }, shop.id)

        rs_trade = response['trade_fullinfo_get_response']['trade']
        rs_orders = rs_trade.delete('orders')["order"]
        tb_trade = Tb::Trade.new(rs_trade)
        tb_trade.shop_id = shop.id

        rs_orders.each do |o|
          tb_trade.orders.build(init_taobao_order(o))
        end
        tb_trade.save
      end
    end

    def update_by_tid(shop, tid)
      begin
        response = Tb::Query.get({
          method: 'taobao.trade.fullinfo.get', tid: tid,
          fields: taobao_trade_get_fields,
          }, shop.id)

        rs_trade = response['trade_fullinfo_get_response']['trade']
        rs_orders = rs_trade.delete('orders')["order"]
        tb_trade = Tb::Trade.find_by_tid(rs_trade["tid"])
        tb_trade.update(rs_trade)

        rs_orders.each do |o|
          tb_order = tb_trade.orders.find_by_oid(o["oid"])
          tb_order.update(init_taobao_order(o))
        end
      end
    end

  private
    def init_taobao_order(response_hash)
      excepts = %w(is_service_order bind_oid ticket_outer_id ticket_expdate_key is_www 
                pic_path seller_nick snapshot_url timeout_action_time buyer_rate seller_rate)

      response_hash.delete_if{|k, v| excepts.include?(k)}
    end

    def taobao_trade_get_fields
      %w(tid status title point_fee  total_fee credit_card_fee
        commission_fee payment post_fee received_payment cod_fee cod_status trade_from trade_memo created   
        end_time modified pay_time consign_time shipping_type alipay_id alipay_no
        buyer_alipay_no buyer_nick buyer_area buyer_email buyer_message buyer_memo 
        seller_nick seller_memo receiver_name receiver_state receiver_city receiver_district receiver_address
        receiver_zip receiver_mobile receiver_phone buyer_obtain_point_fee real_point_fee is_lgtype
        is_brand_sale is_force_wlb is_daixiao orders 
        ).join(", ")
    end
  end
end
