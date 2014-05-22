# encoding : utf-8 -*-
class TaobaoTradePuller
  class << self
    def refresh_trade(shop, tid)
      begin
        response = Tb::Query.get({
          method: 'taobao.trade.fullinfo.get', tid: tid,
          fields: taobao_trade_get_fields,
          }, shop.id)

        rs_trade = response['trade_fullinfo_get_response']['trade']
        create_or_update_taobao_trade(rs_trade.merge({shop_id: shop.id}))
      end
    end

    # def get_sold_by_created(shop, start_at, end_at)
    #   unless start_at.is_a?(Time)
    #     last_trade = Tb::Trade.where(shop_id: shop.id).order("created DESC").first
    #     if last_trade.blank?
    #       start_at = (Time.now + 1.month).beginning_of_day
    #     else
    #       start_at = last_trade.created - 1.month
    #     end
    #   end
    #   end_at = Time.now if end_at.blank?

    #   page_no = 1
    #   while true do
    #     response = Tb::Query.get({
    #       method: 'taobao.trades.sold.get',
    #       fields: taobao_trade_get_fields,
    #       type: sync_taobao_trade_type,
    #       start_created: start_at.strftime("%Y-%m-%d %H:%M:%S"),
    #       end_created: end_at.strftime("%Y-%m-%d %H:%M:%S"),
    #       page_no: page_no,
    #       page_size: 100,
    #       use_has_next: true}, shop.id
    #       )
    #     break if response['trades_sold_get_response'].blank?
    #     next unless response['trades_sold_get_response']['trades']
    #     response['trades_sold_get_response']['trades']['trade'].each do |rs_trade|
    #       create_or_update_taobao_trade(rs_trade.merge({shop_id: shop.id}))
    #     end

    #     break unless response['trades_sold_get_response']['has_next']
    #     page_no += 1
    #   end
    # end

    def increment_get_sold(shop, start_at = nil, end_at = nil)
      current_time = Time.now

      unless start_at.is_a?(Time)
        last_trade = Tb::Trade.where(shop_id: shop.id).order("created DESC").first
        if last_trade.blank?
          start_at = (Time.now - 1.month).beginning_of_day
        else
          start_at = last_trade.created - 1.month
        end
      end
      end_at = current_time if end_at.blank?

      while start_at <= Time.now
        start_at_time = start_at.to_s(:db)
        ended_at_time = start_at.end_of_day.to_s(:db)

        page_no = 1
        while true do
          response = Tb::Query.get({
              method: 'taobao.trades.sold.increment.get',
              fields: taobao_trade_get_fields,
              type: sync_taobao_trade_type,
              start_modified: start_at_time,
              end_modified: ended_at_time,
              page_no: page_no,
              page_size: 100,
              use_has_next: true
              }, shop.id
            )

          puts "-------- " * 8
          p response
          puts "-------- " * 8
          break if response['trades_sold_increment_get_response'].blank?
          next unless response['trades_sold_increment_get_response']['trades']
          response['trades_sold_increment_get_response']['trades']['trade'].each do |rs_trade|
            create_or_update_taobao_trade(rs_trade.merge({shop_id: shop.id}))
          end
          break unless response['trades_sold_increment_get_response']['has_next']
          page_no += 1
        end

        start_at += 1.days
      end
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

    def sync_taobao_trade_type
      'fixed,auction,guarantee_trade,step,independent_simple_trade,independent_shop_trade,auto_delivery,ec,cod,game_equipment,shopex_trade,netcn_trade,external_trade,instant_trade,b2c_cod,hotel_trade,super_market_trade,super_market_cod_trade,taohua,waimai,nopaid,eticket,tmall_i18n'
    end
  private
    def create_or_update_taobao_trade(response_trade)
      rs_orders = response_trade.delete('orders')["order"]
      tb_trade = Tb::Trade.find_or_initialize_by(tid: response_trade["tid"])
      
      if tb_trade.new_record?
        rs_orders.each do |o|
          tb_trade.orders.build(init_taobao_order(o))
        end
      else
        rs_orders.each do |o|
          tb_order = tb_trade.orders.find_by_oid(o["oid"])
          tb_order.update(init_taobao_order(o))
        end
      end
      tb_trade.update(response_trade)
    end

    def init_taobao_order(response_hash)
      excepts = %w(is_service_order bind_oid ticket_outer_id ticket_expdate_key is_www 
                pic_path seller_nick snapshot_url timeout_action_time buyer_rate seller_rate)

      response_hash.delete_if{|k, v| excepts.include?(k)}
    end
  end
end
