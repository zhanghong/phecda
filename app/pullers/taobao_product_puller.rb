# encoding : utf-8 -*-
class TaobaoProductPuller
  class << self
    def pull_shop_categories(shop)
      return unless shop.is_a?(Tb::Shop)

      begin
        response = Tb::Query.get({
                    method: "taobao.sellercats.list.get",
                    nick: shop.nick
                  }, shop.id)
        seller_cats = response["sellercats_list_get_response"]["seller_cats"]["seller_cat"]
        mappings = {"type" => "tb_type"}
        seller_cats.each do |cat|
          cat.keys.each do |k|
            cat[k] = CGI.unescape(cat[k]) if cat[k].is_a?(String)
            cat[mappings[k]] = cat.delete(k) if mappings[k]
          end
          tb_category = Tb::Category.find_or_initialize_by(shop_id: shop.id, cid: cat["cid"])
          tb_category.update(cat)
        end
        # puts "response " * 8
        # p response
        # puts "response " * 8
      rescue
        # puts "______________________"
        # puts "shop: #{shop.id}"
        # p response
        # puts "______________________"
      end
    end

    def pull_detail_item(shop, num_iid)
      begin
        response = Tb::Query.get({
                    method: 'taobao.item.get',
                    fields: 'num,detail_url,title,sku.properties_name,sku.properties,sku.quantity, sku.sku_id, outer_id, product_id, pic_url,cid,price',
                    num_iid: num_iid,
                    nick: shop.nick
                  }, shop.id)

        item = response['item_get_response']['item']
        item_skus = item.delete("skus")
        tb_product = Tb::Product.find_or_initialize_by(shop_id: shop.id, num_iid: num_iid)
        tb_product.update(item)
        tb_product.sync_taobao_skus(item_skus)
      rescue Exception=>e
        # puts "______________________"
        # puts "shop: #{shop.id}, num_iid: #{num_iid}"
        # p response
        # if Rails.env != "production"
        #   puts e.message
        #   e.backtrace.each do |l|
        #     puts l
        #   end
        # end
        # puts "______________________"
      end
    end

    def pull_all_onsale_items(shop)
      return unless shop.is_a?(Tb::Shop)
      page_no, page_size = 1, 50
      total_page = nil
      begin
        while true
          num_iids = []
          response = Tb::Query.get({
                            method: 'taobao.items.onsale.get',
                            fields: 'num_iid',
                            nick: shop.nick,
                            page_no: page_no,
                            page_size: page_size
                          }, shop.id)
          items = response['items_onsale_get_response']['items']['item']
          total_results = response['items_onsale_get_response']['total_results'].to_i
          total_page = (response['items_onsale_get_response']['total_results'].to_f/page_size).ceil
          items.each do |item|
            num_iids << item['num_iid']
          end
          num_iids.each do |num_iid|
            pull_detail_item(shop, num_iid)
          end
          break if page_no >= total_page
          page_no += 1
        end
      rescue
        # puts "______________________"
        # puts "shop: #{shop.id}"
        # p response
        # puts "______________________"
      end
    end
  end
end
