# encoding : utf-8 -*-
require 'spec_helper'

describe Core::Logistic do
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
      let(:deleted_ems) {create(:logistic_ems, account: account, updater: user, deleter: user)}
      let(:logistic_ems) {create(:logistic_ems, account: account, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(logistic_ems.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          logistic_ems.update(updater_id: 0)
          expect(logistic_ems.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          logistic_ems.destroy
          expect(logistic_ems.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(logistic_ems.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          logistic_ems.destroy
          expect(logistic_ems.deleter_id).to eq(user.id)
          expect(logistic_ems.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Core::Logistic.find_by_id(logistic_ems.id)).to eq(logistic_ems)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          logistic_ems.destroy
          expect(Core::Logistic.find_by_id(logistic_ems.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          logistic_ems.destroy
          expect(Core::Logistic.find_by_id(logistic_ems.id)).to eq(nil)
        end
      end
    end
  end

  context "has many association with dependent" do
    [:logistic_areas].each do |name|
      it { should have_many(name).dependent(:destroy)}
    end
  end

  context "has many areas through logistic_areas" do
    it { should have_many(:areas).through(:logistic_areas)}
  end

  [
    {:name => :name, :uniqueness => {scoped: :account_id}, :maximum => 15}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "filter find mine method" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @ems_deleted = create(:logistic_ems, account: @account, updater: @jos, deleter: @alex)
      @ems = create(:logistic_ems, account: @account, updater: @jos, deleter_id: 0)
      @yuantong = create(:logistic_yt, account: @account, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    context "find by updater id" do
      it "matching by update user jos" do
        conds = {updater_id: @jos.id}
        expect(Core::Logistic.find_mine(conds)).to eq([@ems, @yuantong])
      end

      it "non-matching by update user alex" do
        conds = {updater_id: @alex.id}
        expect(Core::Logistic.find_mine(conds)).to eq([])
      end
    end

    context "find by related name" do
      it "matching by name keyword ms" do
        conds = {name: "ms"}
        expect(Core::Logistic.find_mine(conds)).to eq([@ems])
      end

      it "non-matching by name keyword yuantong" do
        conds = {name: "yuantong"}
        expect(Core::Logistic.find_mine(conds)).to eq([])
      end
    end
  end

  context "check shown attributes" do
    it "check list page view attributs" do
      arr = %w(name updater_name updated_at)
      expect(Core::Logistic.list_shown_attributes).to eq(arr)
    end

    it "check show page view attributes" do
      arr = %w(name updater_name created_at updated_at)
      expect(Core::Logistic.detail_shown_attributes).to eq(arr)
    end
  end
end
