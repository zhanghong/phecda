# encoding : utf-8 -*-
require 'spec_helper'

describe Core::Stock do
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
      let(:deleted_stock) {create(:stock_default, account: account, updater: user, deleter: user)}
      let(:core_stock) {create(:stock_default, account: account, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(core_stock.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          core_stock.update(updater_id: 0)
          expect(core_stock.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          core_stock.destroy
          expect(core_stock.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(core_stock.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          core_stock.destroy
          expect(core_stock.deleter_id).to eq(user.id)
          expect(core_stock.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Core::Stock.find_by_id(core_stock.id)).to eq(core_stock)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          core_stock.destroy
          expect(Core::Stock.find_by_id(core_stock.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          core_stock.destroy
          expect(Core::Stock.find_by_id(core_stock.id)).to eq(nil)
        end
      end
    end
  end

  context "has many association with dependent" do
    [:stock_products, :sellers, :stock_bills, :stock_in_bills, :stock_out_bills].each do |name|
      it { should have_many(name).dependent(:destroy)}
    end
  end

  [
    {:name => :name, :uniqueness => {scoped: :account_id}, :maximum => 20}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "check shown attributes" do
    it "check list page view attributs" do
      arr = %w(name sellers_name product_count)
      expect(Core::Stock.list_shown_attributes).to eq(arr)
    end

    it "check show page view attributes" do
      arr = %w(name product_count updater_name created_at updated_at sellers_name)
      expect(Core::Stock.detail_shown_attributes).to eq(arr)
    end
  end

  context "filter find mine method" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @deleted_stock = create(:stock_default, account: @account, updater: @jos, deleter: @jos)
      @default_stock = create(:stock_default, account: @account, updater: @jos, deleter_id: 0)
      @bj_stock = create(:stock_default, name: "北京仓库", account: @account, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    context "find by updater id" do
      it "matching by update user jos" do
        conds = {updater_id: @jos.id}
        expect(Core::Stock.find_mine(conds)).to eq([@default_stock, @bj_stock])
      end

      it "non-matching by update user alex" do
        conds = {updater_id: @alex.id}
        expect(Core::Stock.find_mine(conds)).to eq([])
      end
    end

    context "find by stock name keyword" do
      it "matching by name keyword 默认" do
        conds = {name: "默认"}
        expect(Core::Stock.find_mine(conds)).to eq([@default_stock])
      end

      it "non-matching by name keyword 上海" do
        conds = {name: "上海"}
        expect(Core::Stock.find_mine(conds)).to eq([])
      end
    end
  end
end
