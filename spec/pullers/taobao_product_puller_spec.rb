# encoding: utf-8
require 'spec_helper'

describe TaobaoProductPuller do
  before do
    tb_app_token = create(:tb_app_token)
    @shop = tb_app_token.shop
  end

  context "同步淘宝商品分类" do
    it "同步新接入店铺的商品分类" do
      tb_category = create(:tb_category)
      excon_mock_with("tb_categories/list.json")
      TaobaoProductPuller.pull_shop_categories(@shop)

      tb_category = Tb::Category.find(tb_category.id)
      categories = Tb::Category.all
      cat_names = categories.map(&:name)
      cat_names.size.should   eq(4)
      expect(cat_names).to match_array(["cat_1", "热销", "精品", "精品-特价"])
    end

    it "保存新添加分类&更新已有分类" do
      tb_category = build(:tb_category)
      tb_category.update(shop_id: @shop.id)
      excon_mock_with("tb_categories/list.json")
      TaobaoProductPuller.pull_shop_categories(@shop)

      tb_category = Tb::Category.find(tb_category.id)
      categories = Tb::Category.all
      cat_names = categories.map(&:name)
      cat_names.size.should   eq(3)
      expect(cat_names).to match_array(["热销", "精品", "精品-特价"])
    end
  end

  context "同步淘宝商品方法" do
    it "同步一个有SKU的淘宝商品" do
      excon_mock_with("tb_items/36824405663_has_skus.json")
      TaobaoProductPuller.pull_detail_item(@shop, "36824405663")

      item = Tb::Product.first
      item.title.should eq("Q121 新款A字裙 一步百褶短裙 包臀弹力 糖果色")
      item.cid.should   eq("1623")
      item.num.should   eq(1699)
      item.outer_id.should  eq("Q121")
      item.price.should     eq(15.50)
      item.product_id.should  eq("0")

      skus = item.skus
      skus.count.should   eq(2)

      [
        {
          property_name: "颜色分类",
          property_values: [
            {name: "军绿色", skus: [
              {quantity: 99, sku_id: "38887090523"}
            ]},{name: "天蓝色", skus: [
              {quantity: 100, sku_id: "38887090524"}
            ]}
          ]
        },{
          property_name: "尺码",
          property_values: [
            {name: "均码", skus: [
              {quantity: 99, sku_id: "38887090523"},
              {quantity: 100, sku_id: "38887090524"}
            ]}
          ]
        }
      ].each do |pro_item|
        property = Tb::Property.where(name: pro_item[:property_name], shop_id: @shop.id).first
        property.values.count.should  eq(pro_item[:property_values].size)
        pro_item[:property_values].each do |pro_value|
          color_value = property.values.where(shop_id: @shop.id, name: pro_value[:name]).first
          color_value.should_not  be_nil
          pro_value[:skus].each do |sku_item|
            sku = Tb::Sku.where(shop_id: @shop.id, product_id: item.id, ts_id: sku_item[:sku_id]).first
            sku.quantity.should   eq(sku_item[:quantity])
            sku.property_values.include?(color_value).should be_true
          end
        end
      end
    end

    it "多次同步同一个商品" do
      excon_mock_with("tb_items/36824405663_has_skus.json")
      TaobaoProductPuller.pull_detail_item(@shop, "36824405663")
      TaobaoProductPuller.pull_detail_item(@shop, "36824405663")

      Tb::Product.count.should  eq(1)
      Tb::Sku.count.should  eq(2)
      Tb::Property.count.should   eq(2)
      Tb::PropertyValue.count.should    eq(3)
      Tb::SkuProperty.count.should      eq(4)
    end
  end
end
