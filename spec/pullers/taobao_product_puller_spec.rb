# encoding: utf-8
require 'spec_helper'

describe TaobaoProductPuller do
  before do
    @tb_app_token = create(:tb_app_token)
  end

  context "sync taobao shop categories" do
    it "update old and save new categories" do
      tb_category = build(:tb_category)
      tb_category.update(shop_id: @tb_app_token.shop_id)
      excon_mock_with("tb_categories/list.json")
      TaobaoProductPuller.pull_shop_categories(@tb_app_token.shop)

      tb_category = Tb::Category.find(tb_category.id)
      categories = Tb::Category.all
      cat_names = categories.map(&:name)
      cat_names.size.should   eq(3)
      expect(cat_names).to match_array(["热销", "精品", "精品-特价"])
    end

    it "save as a new shop" do
      tb_category = create(:tb_category)
      excon_mock_with("tb_categories/list.json")
      TaobaoProductPuller.pull_shop_categories(@tb_app_token.shop)

      tb_category = Tb::Category.find(tb_category.id)
      categories = Tb::Category.all
      cat_names = categories.map(&:name)
      cat_names.size.should   eq(4)
      expect(cat_names).to match_array(["cat_1", "热销", "精品", "精品-特价"])
    end
  end
end
