# encoding : utf-8 -*-
require 'spec_helper'

describe Core::Seller do

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
      let(:stock) {create(:stock_default, account: account, updater: user, deleter_id: 0)}
      let(:deleted_seller) {create(:seller_bj, stock: stock, account: account, updater: user, deleter: user)}
      let(:seller_bj) {create(:seller_bj, stock: stock, account: account, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(seller_bj.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          seller_bj.update(updater_id: 0)
          expect(seller_bj.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          seller_bj.destroy
          expect(seller_bj.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(seller_bj.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          seller_bj.destroy
          expect(seller_bj.deleter_id).to eq(user.id)
          expect(seller_bj.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Core::Seller.find_by_id(seller_bj.id)).to eq(seller_bj)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          seller_bj.destroy
          expect(Core::Seller.find_by_id(seller_bj.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          seller_bj.destroy
          expect(Core::Seller.find_by_id(seller_bj.id)).to eq(nil)
        end
      end
    end
  end

  context "has many association with dependent" do
    [:seller_areas].each do |name|
      it { should have_many(name).dependent(:destroy)}
    end
  end

  context "belongs to association" do
    [:stock].each do |name|
      it { should belong_to(name)}
    end
  end

  [
    {:name => :name, :uniqueness => {scoped: :account_id}, :maximum => 20},
    {:name => :fullname, :uniqueness => {scoped: :account_id}, :maximum => 50},
    {:name => :mobile},
    {:name => :email},
    {:name => :stock_id}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "filter find mine method" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @default_stock = create(:stock_default, account: @account, updater: @jos, deleter_id: 0)
      @bj_stock = create(:stock_default, name: "北京仓库", account: @account, updater: @jos, deleter_id: 0)
      @deleted_seller = create(:seller_bj, stock: @default_stock, account: @account, updater: @jos, deleter: @jos)
      @bj_seller = create(:seller_bj, email: "beijing@phe.cn", stock: @bj_stock, account: @account, updater: @jos, parent_id: nil, deleter_id: 0)
      @sh_seller = create(:seller_sh, email: "shanghai@phe.cn", stock: @default_stock, account: @account, updater: @jos, parent_id: nil, deleter_id: 0)
      @hd_seller = create(:seller_bj, email: "sub_bj@phe.cn", name: "海淀经销商", fullname: "海淀经销商", stock: @default_stock, account: @account, updater: @jos, parent_id: @bj_seller.id, deleter_id: 0)

      Account.current = @account
    end

    context "find by seller name" do
      it "matching by name keyword 海淀" do
        conds = {name: "海淀"}
        expect(Core::Seller.find_mine(conds)).to eq([@hd_seller])
      end

      it "non-matching by name keyword shanghai" do
        conds = {name: "shanghai"}
        expect(Core::Seller.find_mine(conds)).to eq([])
      end
    end

    context "find by related stock name" do
      it "matching by name keyword 默认" do
        conds = {stock_name: "默认"}
        expect(Core::Seller.find_mine(conds)).to eq([@sh_seller, @hd_seller])
      end

      it "non-matching by name keyword shanghai" do
        conds = {stock_name: "shanghai"}
        expect(Core::Seller.find_mine(conds)).to eq([])
      end
    end

    context "find by seller mobile" do
      it "matching by mobile keyword 181" do
        conds = {mobile: "181"}
        expect(Core::Seller.find_mine(conds)).to eq([@sh_seller])
      end

      it "non-matching by mobile keyword shanghai" do
        conds = {mobile: "189"}
        expect(Core::Seller.find_mine(conds)).to eq([])
      end
    end

    context "find by seller phone" do
      it "matching by phone keyword 010" do
        conds = {phone: "010"}
        expect(Core::Seller.find_mine(conds)).to eq([@bj_seller, @hd_seller])
      end

      it "non-matching by phone keyword shanghai" do
        conds = {phone: "189"}
        expect(Core::Seller.find_mine(conds)).to eq([])
      end
    end

    context "find by seller email" do
      it "matching by email keyword 010" do
        conds = {email: "beijing"}
        expect(Core::Seller.find_mine(conds)).to eq([@bj_seller])
      end

      it "non-matching by email keyword tianjin" do
        conds = {email: "tianjin"}
        expect(Core::Seller.find_mine(conds)).to eq([])
      end
    end

    context "find by updater id" do
      it "matching by update user jos" do
        conds = {updater_id: @jos.id}
        expect(Core::Seller.find_mine(conds)).to eq([@bj_seller, @sh_seller, @hd_seller])
      end

      it "non-matching by update user alex" do
        conds = {updater_id: @alex.id}
        expect(Core::Seller.find_mine(conds)).to eq([])
      end
    end

    context "find by parent_id" do
      it "matching roots by parent id is 0" do
        conds = {parent_id: 0}
        expect(Core::Seller.find_mine(conds)).to eq([@bj_seller, @sh_seller])
      end

      it "matching by parent beijing seller" do
        conds = {parent_id: @bj_seller.id}
        expect(Core::Seller.find_mine(conds)).to eq([@hd_seller])
      end

      it "non-matching by parent shanghai seller" do
        conds = {updater_id: @sh_seller.id}
        expect(Core::Seller.find_mine(conds)).to eq([])
      end
    end
  end

  context "check shown attributes" do
    it "check list page view attributs" do
      arr = %w(name stock_name mobile phone email)
      expect(Core::Seller.list_shown_attributes).to eq(arr)
    end

    it "check show page view attributes" do
      arr = %w(name fullname stock_name mobile phone email address updater_name updated_at)
      expect(Core::Seller.detail_shown_attributes).to eq(arr)
    end
  end

  context "Core::Seller instance object methods" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @default_stock = create(:stock_default, account: @account, updater: @jos, deleter_id: 0)
      @bj_seller = create(:seller_bj, stock: @default_stock, account: @account, updater_id: @jos, parent_id: nil, deleter_id: 0)
      @hd_seller = create(:seller_bj, name: "海淀经销商", fullname: "海淀经销商", stock: @default_stock, account: @account, updater: @jos, parent: @bj_seller, deleter_id: 0)

      Account.current = @account
    end

    context "show seller stock name" do
      it "return related stock name if stock present" do
        expect(@bj_seller.stock_name).to eq(@default_stock.name)
      end

      it "return nil if related stock destroy" do
        @default_stock.destroy
        @bj_seller.reload
        expect(@bj_seller.stock_name).to eq(nil)
      end
    end

    context "show parent seller name" do
      it "return parent name if seller has parent" do
        expect(@hd_seller.parent_name).to eq(@bj_seller.name)
      end

      it "return nil if related stock destroy" do
        expect(@bj_seller.parent_name).to eq(nil)
      end
    end
  end
end
