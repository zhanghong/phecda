# encoding: utf-8
require 'spec_helper'

def valid_shop_detail(shop)
  local_file_path = "tb_shops/local/shop.yml"
  shop_info = read_yaml(local_file_path)
  shop_info.each do |attr_name, value|
    if %w(created modified).include?(attr_name)
      attr_name = "tb_#{attr_name}_at"
      value = Time.parse(value)
    end
    shop.send(attr_name).should   eq(value)
  end
end

def valid_token_detail(app_token)
  local_file_path = "tb_shops/local/app_token.yml"
  token_info = read_yaml(local_file_path)
  token_info.each do |attr_name, value|
    value = Time.at(value) if attr_name == "expires_at"
    app_token.send(attr_name).should  eq(value)
  end
end

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
      auth_hash = read_yaml("tb_shops/local/auth_hash.yml")

      @tb_shop.destroy
      shop_count = Tb::Shop.count
      app_token_count = Tb::AppToken.count

      excon_mock_with("tb_shops/server/shop.yml")

      shop = Tb::Shop.create_by_omniauth(auth_hash)
      Tb::Shop.count.should  eq(shop_count+1)
      shop.id.should         eq(Tb::Shop.last.id)
      valid_shop_detail(shop)

      token = shop.app_tokens.where(app_id: 1).first
      Tb::AppToken.count.should   eq(app_token_count+1)
      token.id.should             eq(Tb::AppToken.last.id)
      valid_token_detail(token)
    end

    it "re-auth again" do
      auth_hash = read_yaml("tb_shops/local/auth_hash.yml")

      shop_count = Tb::Shop.count
      app_token_count = Tb::AppToken.count

      excon_mock_with("tb_shops/server/shop.yml")

      shop = Tb::Shop.create_by_omniauth(auth_hash)
      Tb::Shop.count.should  eq(shop_count)
      shop.id.should         eq(@tb_shop.id)
      valid_shop_detail(shop)

      token = shop.app_tokens.where(app_id: 1).first
      Tb::AppToken.count.should   eq(app_token_count)
      token.id.should             eq(@tb_app_token.id)
      valid_token_detail(token)
    end
  end

  context "pull taobao shop info" do
    it "get success" do
      excon_mock_with("tb_shops/server/shop.yml")
      @tb_shop.pull_taobao_info
      valid_shop_detail(@tb_shop)
    end
  end
end
