# encoding : utf-8 -*-
#http://galeki.is-programmer.com/posts/32636.html

def load_file(path, file_type)
  Dir.foreach(path) do |file|
    if file != "." && file != ".."
      file_path = File.join(path, file)
      if File.directory?(file_path)
        load_file(file_path, file_type) 
      elsif file_type == "server"
        rewrite_server_yml(file_path)
      elsif file_type == "local"
        rewrite_local_yml(file_path)
      end
    end
  end
end

def rewrite_server_yml(file_path)
  YAML::ENGINE.yamler = 'psych'

  trade_keys = ["alipay_id", "alipay_no", "buyer_nick", "buyer_obtain_point_fee", 
    "cod_fee", "cod_status", "commission_fee", "created", "end_time", 
    "is_brand_sale", "is_force_wlb", "is_lgtype", "modified", "pay_time", 
    "payment", "point_fee", "post_fee", "real_point_fee", "received_payment", 
    "receiver_address", "receiver_city", "receiver_district", "receiver_mobile", 
    "receiver_name", "receiver_phone", "receiver_state", "receiver_zip", "seller_nick", 
    "shipping_type", "status", "tid", "total_fee"]
  order_keys = ["adjust_fee", "cid", "discount_fee", "is_daixiao", "is_oversold", 
    "num", "num_iid", "oid", "order_from", "outer_iid", "part_mjz_discount", 
    "payment", "price", "refund_status", "seller_type", 
    "sku_id", "sku_properties_name", "status", "store_code", "title", "total_fee"]

  yml_data = YAML::load_file(file_path)
  trade = yml_data["trade_fullinfo_get_response"]["trade"]
  trade.each do |key, value|
    if key == "orders"
      value["order"].each do |trade_order|
        trade_order.each do |k, v|
          trade_order.delete(k) unless order_keys.include?(k)
        end
      end
    elsif !trade_keys.include?(key)
      trade.delete(key)
    end
  end
  File.open(file_path, "w"){|f| f.puts yml_data.to_yaml}
end

def rewrite_local_yml(source_file_path)
  YAML::ENGINE.yamler = 'psych'

  money_fields = %W(cod_fee commission_fee adjust_fee discount_fee 
    part_mjz_discount payment price total_fee post_fee received_payment
    )
  integer_fields = %w(buyer_obtain_point_fee num point_fee real_point_fee)
  yml_data = YAML::load_file(source_file_path)
  trade = yml_data["trade_fullinfo_get_response"]["trade"]
  orders = trade.delete("orders")["order"]
  trade.each do |key, value|
    trade[key] =  if money_fields.include?(key)
                    value.to_f 
                  elsif integer_fields.include?(key)
                    value.to_i
                  elsif [true, false].include?(value)
                    value
                  else
                    value.to_s
                  end
  end

  orders.each do |order_item|
    order_item.each do |key, value|
      order_item[key] =  if money_fields.include?(key)
                      value.to_f
                    elsif integer_fields.include?(key)
                      value.to_i
                    elsif [true, false].include?(value)
                      value
                    else
                      value.to_s
                    end
    end
  end

  trade["orders"] = orders
  new_file_path = source_file_path.gsub('server', "local")
  File.open(new_file_path, "w"){|f| f.puts trade.to_yaml}
end


# 重写淘宝订单详细API返回值
# rake rewrite_tb_trade_server_file --trace RAILS_ENV=production
task	:rewrite_tb_trade_server_file => :environment do
  root_path = File.join(Rails.root, "spec/mock_data/tb_trades/server")
  load_file(root_path, "server")
end

# 根据淘宝订单详细API返回值重写本地yml
# rake rewrite_tb_trade_local_file --trace RAILS_ENV=production
task  :rewrite_tb_trade_local_file => :environment do
  root_path = File.join(Rails.root, "spec/mock_data/tb_trades/server")
  load_file(root_path, "local")
end

# 根据淘宝单品详细API返回值重写本地yml
# rake rewrite_tb_product_local_file --trace RAILS_ENV=production
task  :rewrite_tb_product_local_file => :environment do
  YAML::ENGINE.yamler = 'psych'

  root_path = File.join(Rails.root, "spec/mock_data/tb_items/server")
  integer_fields = %w(num price quantity)
  Dir.foreach(root_path) do |file|
    if file != "." && file != ".."
      source_file_path = File.join(root_path, file)
      target_file_path = source_file_path.gsub("server", "local")

      yml_data = YAML::load_file(source_file_path)
      item = yml_data["item_get_response"]["item"]
      
      skus = []
      sku_items = item.delete("skus")["sku"] rescue []
      if sku_items.present?
        sku_items.each do |sku_item|
          sku = {
                  ts_id: sku_item["sku_id"].to_s,
                  quantity: sku_item["quantity"].to_i
                  
                }
          properties = []
          sku_item["properties_name"].split(";").each do |pro_item|
            arr = pro_item.split(":")
            properties << {name: arr[2], value: arr[3]}
          end
          sku[:properties] = properties
          skus << sku
        end
      else
        skus << {
                  ts_id: File.basename(source_file_path, ".yml").split("_").last,
                  is_hide: true
                  
                }
      end

      item.each do |key, value|
        item[key] = if integer_fields.include?(key)
                      value.to_i
                    else
                      value.to_s
                    end
      end
      item["skus"] = skus

      File.open(target_file_path, "w"){|f| f.puts item.to_yaml}
    end
  end
end