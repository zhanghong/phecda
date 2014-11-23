# encoding: utf-8
require 'spec_helper'

describe Sys::SkuPropertyValue do
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
      let(:sys_property) {create(:sys_property, account: account, updater: user, deleter_id: 0)}
      let(:sys_property_value) {create(:sys_property_values, property: sys_property, account: account, updater: user, deleter_id: 0)}
      let(:sys_sku_property_value) {create(:sys_sku_property_value, sku: sys_sku, property_value: sys_property_value, account: account, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(sys_sku_property_value.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          sys_sku_property_value.update(updater_id: 0)
          expect(sys_sku_property_value.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          sys_sku_property_value.destroy
          expect(sys_sku_property_value.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(sys_sku_property_value.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          sys_sku_property_value.destroy
          expect(sys_sku_property_value.deleter_id).to eq(user.id)
          expect(sys_sku_property_value.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Sys::SkuPropertyValue.find_by_id(sys_sku_property_value.id)).to eq(sys_sku_property_value)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          sys_sku_property_value.destroy
          expect(Sys::SkuPropertyValue.find_by_id(sys_sku_property_value.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          sys_sku_property_value.destroy
          expect(Sys::SkuPropertyValue.find_by_id(sys_sku_property_value.id)).to eq(nil)
        end
      end
    end
  end

  context "belongs to association" do
    [:sku, :property_value].each do |name|
      it { should belong_to(name)}
    end
  end
end