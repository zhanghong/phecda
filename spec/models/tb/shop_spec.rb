# encoding: utf-8
require 'spec_helper'

describe Tb::Shop do
  before do
    @tb_app_token = create(:tb_app_token)
    @tb_shop = @tb_app_token.shop
  end

  context "belongs_to association" do
    [:account].each do |name|
      it { should belong_to(name) }
    end
  end

  context "has_many association" do
    [:app_tokens, :categories, :products, :skus, :properties, :property_values].each do |name|
      it { should have_many(name).dependent(:destroy) }
    end
  end

  context "auth shop with omniauth" do
    it "auth a new shop" do
      auth_hash = {
        "credentials" => {
          "expires" => true,
          "expires_at" => 1397976600,
          "refresh_token" => "6201c19fa176dd2506081eaba16ZZf745845a1b335fa977578965845",
          "token" => "62008194e76cc265b1e907a2bb9ZZbd029f26b1567c413954375014"
        },
        "extra" => {
          "raw_info" => {
            "r1_expires_in" => 86400,
            "r2_expires_in" => 86400,
            "re_expires_in" => 86400,
            "taobao_user_id" => "579846587",
            "taobao_user_nick" => "brandy_store",
            "token_type" => "Bearer",
            "w1_expires_in" => 86400,
            "w2_expires_in" => 1800
          }
        }
      }

      @tb_shop.destroy
      shop_count = Tb::Shop.count
      app_token_count = Tb::AppToken.count

      excon_mock_with("tb_shops/detail.json")

      shop = Tb::Shop.create_by_omniauth(auth_hash)
      Tb::Shop.count.should  eq(shop_count+1)
      shop.id.should         eq(Tb::Shop.last.id)
      shop.user_id.should    eq("579846587")
      shop.nick.should       eq("brandy_store")
      shop.cid.should        eq("14")
      shop.sid.should        eq("12345678")
      shop.title.should      eq("Brandy专柜")
      shop.desc.should       eq("店铺描述信息")
      shop.bulletin.should   eq("欢迎大家进店咨询选购")
      shop.pic_path.should   eq("")
      shop.tb_created_at.should eq(Time.parse("2013-12-20 09:00:00"))
      shop.tb_modified_at.should   eq(Time.parse("2014-03-01 12:30:00"))

      token = shop.app_tokens.where(app_id: 1).first
      Tb::AppToken.count.should   eq(app_token_count+1)
      token.id.should             eq(Tb::AppToken.last.id)
      token.expires.should        be_true
      token.expires_at.should     eq(Time.at(1397976600))
      token.r1_expires_in.should  eq(86400)
      token.r2_expires_in.should  eq(86400)
      token.re_expires_in.should  eq(86400)
      token.w1_expires_in.should  eq(86400)
      token.w2_expires_in.should  eq(1800)
      token.user_id.should  eq("579846587")
      token.nick.should  eq("brandy_store")
      token.auth_type.should  eq("oauth2")
      token.token_type.should  eq("Bearer")
      token.refresh_token.should  eq("6201c19fa176dd2506081eaba16ZZf745845a1b335fa977578965845")
      token.access_token.should  eq("62008194e76cc265b1e907a2bb9ZZbd029f26b1567c413954375014")
    end

    it "re-auth again" do
      auth_hash = {
        "credentials" => {
          "expires" => true,
          "expires_at" => 1397976600,
          "refresh_token" => "6201c19fa176dd2506081eaba16ZZf745845a1b335fa977578965845",
          "token" => "62008194e76cc265b1e907a2bb9ZZbd029f26b1567c413954375014"
        },
        "extra" => {
          "raw_info" => {
            "r1_expires_in" => 86400,
            "r2_expires_in" => 86400,
            "re_expires_in" => 86400,
            "taobao_user_id" => "579846587",
            "taobao_user_nick" => "brandy_store",
            "token_type" => "Bearer",
            "w1_expires_in" => 86400,
            "w2_expires_in" => 1800
          }
        }
      }

      shop_count = Tb::Shop.count
      app_token_count = Tb::AppToken.count

      excon_mock_with("tb_shops/detail.json")

      shop = Tb::Shop.create_by_omniauth(auth_hash)
      Tb::Shop.count.should  eq(shop_count)
      shop.id.should         eq(@tb_shop.id)
      shop.user_id.should    eq("579846587")
      shop.nick.should       eq("brandy_store")
      shop.cid.should        eq("14")
      shop.sid.should        eq("12345678")
      shop.title.should      eq("Brandy专柜")
      shop.desc.should       eq("店铺描述信息")
      shop.bulletin.should   eq("欢迎大家进店咨询选购")
      shop.pic_path.should   eq("")
      shop.tb_created_at.should eq(Time.parse("2013-12-20 09:00:00"))
      shop.tb_modified_at.should   eq(Time.parse("2014-03-01 12:30:00"))

      token = shop.app_tokens.where(app_id: 1).first
      Tb::AppToken.count.should   eq(app_token_count)
      token.id.should             eq(@tb_app_token.id)
      token.expires.should        be_true
      token.expires_at.should     eq(Time.at(1397976600))
      token.r1_expires_in.should  eq(86400)
      token.r2_expires_in.should  eq(86400)
      token.re_expires_in.should  eq(86400)
      token.w1_expires_in.should  eq(86400)
      token.w2_expires_in.should  eq(1800)
      token.user_id.should  eq("579846587")
      token.nick.should  eq("brandy_store")
      token.auth_type.should  eq("oauth2")
      token.token_type.should  eq("Bearer")
      token.refresh_token.should  eq("6201c19fa176dd2506081eaba16ZZf745845a1b335fa977578965845")
      token.access_token.should  eq("62008194e76cc265b1e907a2bb9ZZbd029f26b1567c413954375014")
    end
  end

  context "pull taobao shop info" do
    it "get success" do
      excon_mock_with("tb_shops/detail.json")
      @tb_shop.pull_taobao_info
      @tb_shop.cid.should        eq("14")
      @tb_shop.sid.should        eq("12345678")
      @tb_shop.title.should      eq("Brandy专柜")
      @tb_shop.desc.should       eq("店铺描述信息")
      @tb_shop.bulletin.should   eq("欢迎大家进店咨询选购")
      @tb_shop.pic_path.should   eq("")
      @tb_shop.tb_created_at.should eq(Time.parse("2013-12-20 09:00:00"))
      @tb_shop.tb_modified_at.should   eq(Time.parse("2014-03-01 12:30:00"))
    end
  end
end
