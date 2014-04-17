# encoding: utf-8
require 'spec_helper'

describe TaobaoProductPuller do
  before do
    @brandy_store_token = create(:brandy_store_token)
    @brandy_store = @brandy_store_token.shop
  end

  context "valid user name" do
    it "test webmock" do
      excon_mock_with("tb_onsale_items.json")
      num_iid = "11130944"
      response = Tb::Query.get({
                      method: 'taobao.item.get',
                      fields: 'num,detail_url,title,sku.properties_name,sku.properties,sku.quantity, sku.sku_id, outer_id, product_id, pic_url,cid,price',
                      num_iid: num_iid,
                      nick: @brandy_store.nick
                    }, @brandy_store.id)
      p response
    end
  end
end
