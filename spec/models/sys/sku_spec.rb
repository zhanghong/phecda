# encoding: utf-8
require 'spec_helper'

describe Sys::Sku do
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
      let(:delete_sys_sku) {create(:sys_sku, product: sys_product, account: account, updater: user, deleter: user)}
      let(:sys_sku) {create(:sys_sku, product: sys_product, account: account, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(sys_sku.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          sys_sku.update(updater_id: 0)
          expect(sys_sku.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          sys_sku.destroy
          expect(sys_sku.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(sys_sku.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          sys_sku.destroy
          expect(sys_sku.deleter_id).to eq(user.id)
          expect(sys_sku.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Sys::Sku.find_by_id(sys_sku.id)).to eq(sys_sku)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          sys_sku.destroy
          expect(Sys::Sku.find_by_id(sys_sku.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          sys_sku.destroy
          expect(Sys::Sku.find_by_id(sys_sku.id)).to eq(nil)
        end
      end
    end
  end

  context "belongs to association" do
    [:product].each do |name|
      it { should belong_to(name)}
    end
  end

  context "has many association" do
    it "have many sku_bindings with foreign key sys_sku_id" do
      should have_many(:sku_bindings).with_foreign_key("sys_sku_id")
    end
  end

  context "has many through" do
    it "have many skus through sku_bindings" do
     should have_many(:skus).through(:sku_bindings)
    end
  end

  context "has many and belongs_to association" do
    [:property_values].each do |name|
      it { should have_and_belong_to_many(name)}
    end
  end

  [
    {:name => :name, :uniqueness => {scoped: :account_id}, :maximum => 50},
    {:name => :number},
    {:name => :price}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "validate number is greater than or equal to 0" do
    it {should validate_numericality_of(:number).is_greater_than_or_equal_to(0)}
  end

  context "validate price is between  0 and 999999.99" do
    it {should validate_numericality_of(:price).is_greater_than_or_equal_to(0).is_less_than(999999.99)}
  end

  context "filter find mine method" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @sys_category = create(:sys_category, account: @account, updater: @jos, deleter_id: 0)
      @sys_product = create(:sys_product, category: @sys_category, account: @account, updater: @jos, deleter_id: 0)
      @delete_sys_sku = create(:sys_sku, name: "已删除sku", product: @sys_product, account: @account, updater: @jos, deleter: @jos)
      @sys_sku = create(:sys_sku, name: "测试sys sku", product: @sys_product, account: @account, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    context "find by sys sku name" do
      it "matching by name sys" do
        conds = {name: "sys"}
        expect(Sys::Sku.find_mine(conds)).to eq([@sys_sku])
      end

      it "non-matching by name keyword 删除" do
        conds = {name: "删除"}
        expect(Sys::Sku.find_mine(conds)).to eq([])
      end
    end

    context "find by sys sku id" do
      it "matching by sys_sku's id" do
        conds = {id: @sys_sku.id}
        expect(Sys::Sku.find_mine(conds)).to eq([@sys_sku])
      end

      it "non-matching by delete_sys_sku's id" do
        conds = {id: @delete_sys_sku.id}
        expect(Sys::Sku.find_mine(conds)).to eq([])
      end
    end

    context "find by related sys product id" do
      it "matching by sys_product's id" do
        conds = {product_id: @sys_product.id}
        expect(Sys::Sku.find_mine(conds)).to eq([@sys_sku])
      end

      it "non-matching by new sys_product's id" do
        @new_sys_product = create(:sys_product, title: "new product", category: @sys_category, account: @account, updater: @jos, deleter_id: 0)
        conds = {product_id: @new_sys_product.id}
        expect(Sys::Sku.find_mine(conds)).to eq([])
      end
    end

    # context "find by property state" do
    #   it "matching by state activted" do
    #     conds = {state: "activted"}
    #     expect(Sys::Sku.find_mine(conds)).to eq([@sys_sku])
    #   end

    #   it "non-matching by state hidden" do
    #     conds = {state: "hidden"}
    #     expect(Sys::Sku.find_mine(conds)).to eq([])
    #   end
    # end
  end

  context "Sys::Sku instance object methods" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @sys_category = create(:sys_category, account: @account, updater: @jos, deleter_id: 0)
      @sys_product = create(:sys_product, category: @sys_category, account: @account, updater: @jos, deleter_id: 0)
      @sys_sku = create(:sys_sku, name: "测试sys sku", product: @sys_product, account: @account, updater: @jos, deleter_id: 0)
      @property_color = create(:sys_property, name: "color", account: @account, updater: @jos, deleter_id: 0)
      @pro_value_red = create(:sys_property_values, name: "red", property: @property_color, account: @account, updater: @jos, deleter_id: 0)
      @pro_value_yellow = create(:sys_property_values, name: "yellow", property: @property_color, account: @account, updater: @jos, deleter_id: 0)
      @sys_sku.property_values = [@pro_value_red]
      Account.current = @account
    end

    context "return instance related Sys::Product instances title" do
      it "return relatated Sys::Product's title when it present" do
        expect(@sys_sku.product_name).to eq(@sys_product.title)
      end

      it "return relatated Sys::Product's title when it destroy" do
        @sys_product.destroy
        expect(@sys_sku.product_name).to eq(@sys_product.title)
      end

      it "return nil when related Sys::Product is nil" do
        @sys_sku.product = nil
        expect(@sys_sku.product_name).to eq(nil)
      end
    end

    context "return instance related Sys::PropertyValue instances ids" do
      it "return relatated Sys::Product's id as a array when it present" do
        expect(@sys_sku.property_values_ids).to eq([@pro_value_red.id])
      end

      it "return a empty array when it not related Sys::PropertyValue" do
        @sys_sku.property_values = []
        expect(@sys_sku.property_values_ids).to eq([])
      end
    end

    context "return instance related Sys::PropertyValue instances names" do
      it "return relatated Sys::Product's name as a array when it present" do
        expect(@sys_sku.property_values_name).to eq([@pro_value_red.value_name])
      end

      it "return a empty array when it not related Sys::PropertyValue" do
        @sys_sku.property_values = []
        expect(@sys_sku.property_values_name).to eq([])
      end
    end

    context "save self property values" do
      it "save new value with skip old and empty item" do
        @sys_sku.update(pro_values_ids: [0, nil, @pro_value_red.id, @pro_value_yellow.id])
        expect(@sys_sku.property_values.count).to eq(2)
        new_value = @sys_sku.property_values.last
        expect(new_value.id).to eq(@pro_value_yellow.id)
        expect(new_value.account_id).to eq(@sys_sku.account_id)
      end

      it "save new value and delete old item" do
        @sys_sku.update(pro_values_ids: [@pro_value_yellow.id])
        expect(@sys_sku.property_values.count).to eq(1)
        new_value = @sys_sku.property_values.last
        expect(new_value.id).to eq(@pro_value_yellow.id)
        expect(new_value.account_id).to eq(@sys_sku.account_id)
      end

      it "delete all old values when parameter is empty" do
        @sys_sku.update(pro_values_ids: [])
        expect(@sys_sku.property_values.count).to eq(0)
      end
    end
  end
end