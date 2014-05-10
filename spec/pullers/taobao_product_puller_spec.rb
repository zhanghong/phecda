# encoding: utf-8
require 'spec_helper'

def valid_product_fullinfo(file_name)
  local_file_path = "tb_items/local/#{file_name}"
  num_iid = File.basename(file_name, ".yml").split("_").last

  product_info = read_yaml(local_file_path)
  sku_items = product_info.delete("skus")

  tb_products = Tb::Product.where(shop_id: @shop.id, num_iid: num_iid)
  tb_products.count.should  eq(1)

  tb_product = tb_products.first
  product_info.each do |attr_name, value|
    tb_product.send(attr_name).should   eq(value)
  end

  tb_product.skus.count.should  eq(sku_items.size)
  sku_items.each do |sku_item|
    sku_properties = sku_item.delete(:properties)

    tb_sku = tb_product.skus.where(ts_id: sku_item[:ts_id]).first
    sku_item.each do |attr_name, value|
      tb_sku.send(attr_name).should   eq(value)
    end

    sku_properties.each do |pro_item|
      tb_properties = Tb::Property.where(shop_id: @shop.id, name: pro_item[:name])
      tb_properties.count.should  eq(1)
      property_id = tb_properties.first.id

      tb_values = Tb::PropertyValue.where(shop_id: @shop.id, property_id: property_id, name: pro_item[:value])
      tb_values.count.should  eq(1)
      tb_sku.sku_properties.where(property_value_id: tb_values.first.id).count.should   eq(1)  
    end if sku_properties
  end 
end

describe TaobaoProductPuller do
  before do
    @tb_app_token = create(:tb_app_token)
    @shop = @tb_app_token.shop
  end

  context "同步淘宝商品分类" do
    it "同步新接入店铺的商品分类" do
      tb_category = create(:tb_category)
      excon_mock_with("tb_categories/list.yml")
      TaobaoProductPuller.pull_shop_categories(@shop)

      tb_category = Tb::Category.find(tb_category.id)
      categories = Tb::Category.all
      cat_names = categories.map(&:name)
      cat_names.size.should   eq(4)
      expect(cat_names).to match_array(["cat_1", "热销", "精品", "特价"])
    end

    it "保存新添加分类&更新已有分类" do
      tb_category = build(:tb_category)
      tb_category.update(shop_id: @shop.id)
      excon_mock_with("tb_categories/list.yml")
      TaobaoProductPuller.pull_shop_categories(@shop)

      tb_category = Tb::Category.find(tb_category.id)
      categories = Tb::Category.all
      cat_names = categories.map(&:name)
      cat_names.size.should   eq(3)
      expect(cat_names).to match_array(["热销", "精品", "特价"])
    end
  end

  [
    {
      file_name: "has_sku_36817355732.yml"
    },{
      file_name: "has_sku_36863990457.yml"
    },{
      file_name: "no_sku_13346953735.yml"
    }
  ].each do |pull_item|
    context "同步淘宝商品方法" do
      it "第一次同步 #{pull_item[:file_name]}" do
        yml_file_name = pull_item[:file_name]
        num_iid = File.basename(yml_file_name, ".yml").split("_").last
        excon_mock_with("tb_items/server/#{yml_file_name}")
        TaobaoProductPuller.pull_detail_item(@shop, num_iid)

        valid_product_fullinfo(yml_file_name)
      end

      it "同步多次 #{pull_item[:file_name]}" do
        yml_file_name = pull_item[:file_name]
        num_iid = File.basename(yml_file_name, ".yml").split("_").last
        excon_mock_with("tb_items/server/#{yml_file_name}")
        TaobaoProductPuller.pull_detail_item(@shop, num_iid)
        TaobaoProductPuller.pull_detail_item(@shop, num_iid)

        valid_product_fullinfo(yml_file_name)
      end
    end
  end

  context "同步淘宝在售商品" do
    it "同步所有淘宝在售商品" do
      Excon.defaults[:mock] = true
      sub_time

      default_params = {access_token: @tb_app_token.access_token,
        format: "json",
        v: "2.0",
        nick: @shop.nick,
        timestamp: Time.now.strftime("%Y-%m-%d %H:%M:%S")
      }

      onsale_params = default_params.merge({
                        method: "taobao.items.onsale.get",
                        fields: "num_iid",
                        page_size: 50
                      })
      1.upto(2).each do |page_no|
        yml_data = read_yaml("tb_items/onsale_page_#{page_no}.yml")
        Excon.stub({:query => onsale_params.merge(page_no: page_no)}, {:body => yml_data.to_json, :status => 200})
      end

      detail_params = default_params.merge({
          method: 'taobao.item.get',
          fields: 'num,detail_url,title,sku.properties_name,sku.properties,sku.quantity, sku.sku_id, outer_id, product_id, pic_url,cid,price'
        })

        [
          [36817355732, "tb_items/server/has_sku_36817355732.yml"],
          [35051372439, "tb_items/server/no_sku_35051372439.yml"]
        ].each do |num_item|

        yml_data = read_yaml(num_item.last)
        Excon.stub({:query => detail_params.merge(num_iid: num_item.first)}, {:body => yml_data.to_json, :status => 200})
      end
      TaobaoProductPuller.pull_all_onsale_items(@shop)

      Tb::Product.where(num_iid: ["36817355732", "35051372439"]).count.should eq(2)
    end
  end
end
