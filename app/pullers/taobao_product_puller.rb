# encoding : utf-8 -*-
class TaobaoProductPuller
  def self.pull_shop_categories(shop)
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

  def self.pull_detail_item(shop, num_iid)
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
      if item_skus && item_skus["sku"]
        item_skus["sku"].each do |sku_pro|
          sku = Tb::Sku.find_or_initialize_by(shop_id: shop.id, product_id: tb_product.id, ts_id: sku_pro["sku_id"])
          sku.update(quantity: sku_pro["quantity"])
          sku_pro["properties_name"].to_s.split(";").each do |pro_str|
            pid, nid, name, value = pro_str.split(":")
            property = Tb::Property.find_or_create_by(shop_id: shop.id, name: name)
            value =  Tb::PropertyValue.find_or_create_by(shop_id: shop.id, property_id: property.id, name: value)
            Tb::SkuProperty.find_or_create_by(sku_id: sku.id, property_value_id: value.id)
          end
        end
      else
        #puts "no skus num_iid:#{num_iid}"
      end
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

  def self.pull_all_onsale_items(shop)
    return unless shop.is_a?(Tb::Shop)
    page_no, page_size = 1, 50
    total_page = nil
    begin
      while true
        puts "pgae_no:#{page_no}"
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
        break if page_no >= total_page
        page_no += 1
      end
    rescue
      # puts "______________________"
      # puts "shop: #{shop.id}"
      # p response
      # puts "______________________"
    end

    num_iids.each do |num_iid|
      pull_detail_item(shop, num_iid)
    end
  end
end
