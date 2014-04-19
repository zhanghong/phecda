# encoding: utf-8
require 'spec_helper'

describe Tb::Shop do
  before do
    @brandy_store_token = create(:brandy_store_token)
    @brandy_store = @brandy_store_token.shop
  end

  context "belongs_to association" do
    [:account].each do |name|
      it { should belong_to(name) }
    end
  end

  context "has_many association" do
    [:app_tokens, :categories, :products, :skus, :properties, :property_values].each do |name|
      it { should have_many(name) }
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
            "taobao_user_id" => "00001001",
            "taobao_user_nick" => "brandy_store_token",
            "token_type" => "Bearer",
            "w1_expires_in" => 86400,
            "w2_expires_in" => 1800
          }
        }
      }

      @brandy_store.destroy
      shop_count = Tb::Shop.count
      app_token_count = Tb::AppToken.count

      excon_mock_with("tb_shops/brandy_store_info.json")

      shop = Tb::Shop.create_by_omniauth(auth_hash)
      Tb::Shop.count.should  eq(shop_count+1)
      shop.id.should         eq(Tb::Shop.last.id)
      shop.user_id.should    eq("00001001")
      shop.nick.should       eq("brandy_store_token")
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
      token.user_id.should  eq("00001001")
      token.nick.should  eq("brandy_store_token")
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
            "taobao_user_id" => "00001001",
            "taobao_user_nick" => "brandy_store_token",
            "token_type" => "Bearer",
            "w1_expires_in" => 86400,
            "w2_expires_in" => 1800
          }
        }
      }

      shop_count = Tb::Shop.count
      app_token_count = Tb::AppToken.count

      excon_mock_with("tb_shops/brandy_store_info.json")

      shop = Tb::Shop.create_by_omniauth(auth_hash)
      Tb::Shop.count.should  eq(shop_count)
      shop.id.should         eq(@brandy_store.id)
      shop.user_id.should    eq("00001001")
      shop.nick.should       eq("brandy_store_token")
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
      token.id.should             eq(@brandy_store_token.id)
      token.expires.should        be_true
      token.expires_at.should     eq(Time.at(1397976600))
      token.r1_expires_in.should  eq(86400)
      token.r2_expires_in.should  eq(86400)
      token.re_expires_in.should  eq(86400)
      token.w1_expires_in.should  eq(86400)
      token.w2_expires_in.should  eq(1800)
      token.user_id.should  eq("00001001")
      token.nick.should  eq("brandy_store_token")
      token.auth_type.should  eq("oauth2")
      token.token_type.should  eq("Bearer")
      token.refresh_token.should  eq("6201c19fa176dd2506081eaba16ZZf745845a1b335fa977578965845")
      token.access_token.should  eq("62008194e76cc265b1e907a2bb9ZZbd029f26b1567c413954375014")
    end
  end

  context "pull taobao shop info" do
    it "get success" do
      excon_mock_with("tb_shops/brandy_store_info.json")
      @brandy_store.pull_taobao_info
      @brandy_store.cid.should        eq("14")
      @brandy_store.sid.should        eq("12345678")
      @brandy_store.title.should      eq("Brandy专柜")
      @brandy_store.desc.should       eq("店铺描述信息")
      @brandy_store.bulletin.should   eq("欢迎大家进店咨询选购")
      @brandy_store.pic_path.should   eq("")
      @brandy_store.tb_created_at.should eq(Time.parse("2013-12-20 09:00:00"))
      @brandy_store.tb_modified_at.should   eq(Time.parse("2014-03-01 12:30:00"))
    end
  end
end
