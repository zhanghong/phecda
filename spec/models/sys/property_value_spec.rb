# encoding: utf-8
require 'spec_helper'

describe Sys::PropertyValue do
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
      let(:sys_property) {create(:sys_property, account: account, updater: user, deleter_id: 0)}
      let(:delete_property_value) {create(:sys_property_values, property: sys_property, account: account, updater: user, deleter: user)}
      let(:property_value) {create(:sys_property_values, property: sys_property, account: account, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(property_value.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          property_value.update(updater_id: 0)
          expect(property_value.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          property_value.destroy
          expect(property_value.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(property_value.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          property_value.destroy
          expect(property_value.deleter_id).to eq(user.id)
          expect(property_value.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Sys::PropertyValue.find_by_id(property_value.id)).to eq(property_value)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          property_value.destroy
          expect(Sys::PropertyValue.find_by_id(property_value.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          property_value.destroy
          expect(Sys::PropertyValue.find_by_id(property_value.id)).to eq(nil)
        end
      end
    end
  end

  context "has many and belongs_to association" do
    [:skus].each do |name|
      it { should have_and_belong_to_many(name)}
    end
  end

  context "belongs to association" do
    [:property].each do |name|
      it { should belong_to(name)}
    end
  end

  [
    {:name => :name, :uniqueness => {scoped: :property_id}, :maximum => 20}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "Sys::PropertyValue instance object methods" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @property_color = create(:sys_property, name: "color", account: @account, updater: @jos, deleter_id: 0)
      @pro_value_red = create(:sys_property_values, name: "red", property: @property_color, account: @account, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    context "return instance name that with related property name" do
      it "return name with property name when related property present" do
        name = "#{@property_color.name}:#{@pro_value_red.name}"
        expect(@pro_value_red.value_name).to eq(name)
      end

      it "return name with property name when related property destroy" do
        @property_color.destroy
        name = "#{@property_color.name}:#{@pro_value_red.name}"
        expect(@pro_value_red.value_name).to eq(name)
      end

      it "catch expection and return self name when find related property failed" do
        @pro_value_red.property = nil
        name = "未知:#{@pro_value_red.name}"
        expect(@pro_value_red.value_name).to eq(name)
      end
    end
  end
end
