# encoding: utf-8
require 'spec_helper'

describe Sys::CategoryProperty do
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
      let(:sys_property) {create(:sys_property, account: account, updater: user, deleter_id: 0)}
      let(:delete_category_property) {create(:sys_categories_properties, category: sys_category, property: sys_property, account: account, updater: user, deleter: user)}
      let(:sys_category_property) {create(:sys_categories_properties, category: sys_category, property: sys_property, account: account, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(sys_category_property.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          sys_category_property.update(updater_id: 0)
          expect(sys_category_property.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          sys_category_property.destroy
          expect(sys_category_property.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(sys_category_property.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          sys_category_property.destroy
          expect(sys_category_property.deleter_id).to eq(user.id)
          expect(sys_category_property.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Sys::CategoryProperty.find_by_id(sys_category_property.id)).to eq(sys_category_property)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          sys_category_property.destroy
          expect(Sys::CategoryProperty.find_by_id(sys_category_property.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          sys_category_property.destroy
          expect(Sys::CategoryProperty.find_by_id(sys_category_property.id)).to eq(nil)
        end
      end
    end
  end

  context "belongs to association" do
    [:category, :property].each do |name|
      it { should belong_to(name)}
    end
  end
end
