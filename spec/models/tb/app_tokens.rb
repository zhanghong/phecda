# encoding: utf-8
require 'spec_helper'
require "httparty/response"

describe Tb::AppToken do
  before do
    # @account = create(:account)
    @brandy_store_token = create(:brandy_store_token)
  end

  context "valid user name" do
    it "test webmock" do
      #p create(:account)
      puts "=========== " * 8
      p @brandy_store_token.shop.account
      puts "=========== " * 8
    end
  end
end
