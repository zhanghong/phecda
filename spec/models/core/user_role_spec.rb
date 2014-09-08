# encoding : utf-8 -*-
require 'spec_helper'

describe Core::UserRole do
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
      let(:role) {create(:core_role, account: account, updater: user, deleter_id: 0)}
      let(:user_role) {create(:core_user_role, account: account, user: user, role: role, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(user_role.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          user_role.update(updater_id: 0)
          expect(user_role.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          user_role.destroy
          expect(user_role.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(user_role.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          user_role.destroy
          expect(user_role.deleter_id).to eq(user.id)
          expect(user_role.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Core::UserRole.find_by_id(user_role.id)).to eq(user_role)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          user_role.destroy
          expect(Core::UserRole.find_by_id(user_role.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          user_role.destroy
          expect(Core::UserRole.find_by_id(user_role.id)).to eq(nil)
        end
      end
    end
  end

  [
    {:name => :role_id, :uniqueness => {scoped: :user_id}},
    {:name => :user_id, :uniqueness => {scoped: :role_id}}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "belongs to association" do
    [:role, :user].each do |name|
      it { should belong_to(name)}
    end
  end

  context "check shown attributes" do
    it "check list page view attributs" do
      arr = %w()
      expect(Core::UserRole.list_shown_attributes).to eq(arr)
    end

    it "check show page view attributes" do
      arr = %w()
      expect(Core::UserRole.detail_shown_attributes).to eq(arr)
    end
  end

  context "filter find mine method" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @role_cs = create(:core_role, name: "客服", account: @account, updater: @jos, deleter_id: 0)
      @role_op = create(:core_role, name: "运营", account: @account, updater: @jos, deleter: @jos)
      @jos_cs = create(:core_user_role, account: @account, user: @jos, role: @role_cs, updater: @jos, deleter_id: 0)
      @jos_op = create(:core_user_role, account: @account, user: @jos, role: @role_op, updater: @jos, deleter: @jos)
      @alex_cs = create(:core_user_role, account: @account, user: @alex, role: @role_cs, updater: @jos, deleter_id: 0)
      @alex_op = create(:core_user_role, account: @account, user: @alex, role: @role_op, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    context "find by updater id" do
      it "matching by update user jos" do
        conds = {updater_id: @jos.id}
        expect(Core::UserRole.find_mine(conds)).to eq([@jos_cs, @alex_cs, @alex_op])
      end

      it "non-matching by update user alex" do
        conds = {updater_id: @alex.id}
        expect(Core::UserRole.find_mine(conds)).to eq([])
      end
    end

    context "find by related user id" do
      it "matching by related user jos" do
        conds = {user_id: @jos.id}
        expect(Core::UserRole.find_mine(conds)).to eq([@jos_cs])
      end

      it "non-matching by new user" do
        conds = {user_id: create(:user, name: "zon").id}
        expect(Core::UserRole.find_mine(conds)).to eq([])
      end
    end

    context "find by related role id" do
      it "matching by related role role_op" do
        conds = {role_id: @role_op.id}
        expect(Core::UserRole.find_mine(conds)).to eq([@alex_op])
      end

      it "non-matching by new role" do
        role = create(:core_role, name: "财务", account: @account, updater: @jos, deleter: @jos)
        conds = {role_id: role.id}
        expect(Core::UserRole.find_mine(conds)).to eq([])
      end
    end    
  end

  context "return association object name" do
    let(:account) {create(:brandy_account)}
      let(:user) {create(:user)}
      let(:role) {create(:core_role, account: account, updater: user, deleter_id: 0)}
      let(:user_role) {create(:core_user_role, account: account, user: user, role: role, updater: user, deleter_id: 0)}

      it "return related user name" do
        expect(user_role.user_name).to eq(user.name)
      end 

      it "return related role name" do
        expect(user_role.role_name).to eq(role.name)
      end
  end
end
