# encoding: utf-8
require 'spec_helper'

describe Core::StockProduct do
  context "valid methods in scope helper" do
    context "belongs to association" do
      [:account].each do |name|
        it { should belong_to(name)}
      end

      [:updater, :deleter].each do |name|
        it { should belong_to(name)}
      end
    end

    context "test scope helper methods" do
      let(:account) {create(:brandy_account)}
      let(:user) {create(:user)}
      let(:sys_category) {create(:sys_category, account: account, updater: user, deleter_id: 0)}
      let(:sys_product) {create(:sys_product, category: sys_category, account: account, updater: user, deleter_id: 0)}
      let(:sys_sku) {create(:sys_sku, product: sys_product, account: account, updater: user, deleter_id: 0)}
      let(:core_stock) {create(:stock_default, account: account, updater: user, deleter_id: 0)}
      let(:delete_core_stock_product) {create(:core_stock_product, stock: core_stock, product: sys_product, sku: sys_sku, account: account, updater: user, deleter_id: user)}
      let(:core_stock_product) {create(:core_stock_product, stock: core_stock, product: sys_product, sku: sys_sku, account: account, updater: user, deleter_id: 0)}
      context "return updater user name" do
        it "return association user name if has updater" do
          expect(core_stock_product.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          core_stock_product.update(updater_id: 0)
          expect(core_stock_product.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          core_stock_product.destroy
          expect(core_stock_product.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(core_stock_product.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          core_stock_product.destroy
          expect(core_stock_product.deleter_id).to eq(user.id)
          expect(core_stock_product.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Core::StockProduct.find_by_id(core_stock_product.id)).to eq(core_stock_product)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          core_stock_product.destroy
          expect(Core::StockProduct.find_by_id(core_stock_product.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          core_stock_product.destroy
          expect(Core::StockProduct.find_by_id(core_stock_product.id)).to eq(nil)
        end
      end
    end
  end

  context "belongs to association" do
    [:stock, :product, :sku].each do |name|
      it { should belong_to(name)}
    end
  end

  [
    {:name => :stock_id, :uniqueness => {scoped: [:account_id, :sys_sku_id]}},
    {:name => :sys_product_id},
    {:name => :sys_sku_id, :uniqueness => {scoped: [:account_id, :stock_id]}},
    {:name => :activite_num, :numericality => true},
    {:name => :actual_num, :numericality => true}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "filter find mine method" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @sys_category = create(:sys_category, account: @account, updater: @jos, deleter_id: 0)
      @sys_product = create(:sys_product, title: "测试sys商品", category: @sys_category, account: @account, updater: @jos, deleter_id: 0)
      @sys_sku = create(:sys_sku, product: @sys_product, account: @account, updater: @jos, deleter_id: 0)
      @core_stock = create(:stock_default, account: @account, updater: @jos, deleter_id: 0)
      @delete_core_stock_product = create(:core_stock_product, activite_num: 100, actual_num: 20, stock: @core_stock, product: @sys_product, sku: @sys_sku, account: @account, updater: @jos, deleter_id: @jos)
      @core_stock_product = create(:core_stock_product, activite_num: 100, actual_num: 20, stock: @core_stock, product: @sys_product, sku: @sys_sku, account: @account, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    context "find by sys product title" do
      it "matching by keyword sys" do
        conds = {product_name: "sys"}
        expect(Core::StockProduct.find_mine(conds)).to eq([@core_stock_product])
      end

      it "non-matching by name keyword 删除" do
        conds = {product_name: "删除"}
        expect(Core::StockProduct.find_mine(conds)).to eq([])
      end
    end

    context "find by Core::StockProduct's activite number" do
      it "matching by activite number  100" do
        conds = {activite_num: 100}
        expect(Core::StockProduct.find_mine(conds)).to eq([@core_stock_product])
      end

      it "non-matching by activite number 0" do
        conds = {activite_num: 0}
        expect(Core::StockProduct.find_mine(conds)).to eq([])
      end
    end

    context "find by Core::StockProduct's actual number" do
      it "matching by actual number  20" do
        conds = {actual_num: 20}
        expect(Core::StockProduct.find_mine(conds)).to eq([@core_stock_product])
      end

      it "non-matching by actual number 9" do
        conds = {actual_num: 9}
        expect(Core::StockProduct.find_mine(conds)).to eq([])
      end
    end
  end

  context "Core::StockProduct instance object methods" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @sys_category = create(:sys_category, account: @account, updater: @jos, deleter_id: 0)
      @sys_product = create(:sys_product, title: "测试sys商品", category: @sys_category, account: @account, updater: @jos, deleter_id: 0)
      @sys_sku = create(:sys_sku, product: @sys_product, account: @account, updater: @jos, deleter_id: 0)
      @core_stock = create(:stock_default, account: @account, updater: @jos, deleter_id: 0)
      @core_stock_product = create(:core_stock_product, activite_num: 100, actual_num: 20, stock: @core_stock, product: @sys_product, sku: @sys_sku, account: @account, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    context "return instance related Sys::Product instances title" do
      it "return relatated Sys::Product's title when it present" do
        expect(@core_stock_product.product_title).to eq(@sys_product.title)
      end

      it "return relatated Sys::Product's title when it destroy" do
        @sys_product.destroy
        expect(@core_stock_product.product_title).to eq(@sys_product.title)
      end

      it "return nil when related Sys::Product is nil" do
        @core_stock_product.product = nil
        expect(@core_stock_product.product_title).to eq(nil)
      end
    end

    context "return instance related Sys::Sku instances name" do
      it "return relatated Sys::Sku's name when it present" do
        expect(@core_stock_product.sku_name).to eq(@sys_sku.name)
      end

      it "return relatated Sys::Sku's name when it destroy" do
        @sys_product.destroy
        expect(@core_stock_product.sku_name).to eq(@sys_sku.name)
      end

      it "return nil when related Sys::Sku is nil" do
        @core_stock_product.sku = nil
        expect(@core_stock_product.sku_name).to eq(nil)
      end
    end
  end
end
