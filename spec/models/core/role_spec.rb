# encoding : utf-8 -*-
require 'spec_helper'

describe Core::Role do
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

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(role.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          role.update(updater_id: 0)
          expect(role.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          role.destroy
          expect(role.deleter_name).to eq(user.name)
        end

        it "return nil if destroy by nil user" do
          role.destroy
          expect(role.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          role.destroy
          expect(role.deleter_id).to eq(user.id)
          expect(role.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Core::Role.find_by_id(role.id)).to eq(role)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          role.destroy
          expect(Core::Role.find_by_id(role.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          role.destroy
          expect(Core::Role.find_by_id(role.id)).to eq(nil)
        end
      end
    end
  end

  [
    {:name => :name, :uniqueness => {scoped: :account_id}, :maximum => 20}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "has many association with dependent" do
    [:user_roles, :role_permissions].each do |name|
      it { should have_many(name).dependent(:destroy)}
    end
  end

  context "has many users through user_roles" do
    it { should have_many(:users).through(:user_roles)}
  end

  context "check shown attributes" do
    it "check list page view attributs" do
      arr = %w(name user_count updated_at)
      expect(Core::Role.list_shown_attributes).to eq(arr)
    end

    it "check show page view attributes" do
      arr = %w(name updater_name created_at updated_at)
      expect(Core::Role.detail_shown_attributes).to eq(arr)
    end
  end

  context "filter find mine method" do
    before :each do
      @account = create(:brandy_account)
      @user = create(:user)
      @role = create(:core_role, account: @account, updater: @user, deleter_id: 0)
      Account.current = @account
    end

    context "find by name" do
      it "matching by name key world admin" do
        conds = {name: "adm"}
        expect(Core::Role.find_mine(conds)).to eq([@role])
      end

      it "non-matching when current account nil" do
        Account.current = nil
        conds = {name: "adm"}
        expect(Core::Role.find_mine(conds)).to eq([])
      end

      it "non-matching by name key world super" do
        conds = {name: "super"}
        expect(Core::Role.find_mine(conds)).to eq([])
      end
    end

    context "find by updater user id" do
      it "matching by updater id" do
        conds = {updater_id: @user.id}
        expect(Core::Role.find_mine(conds)).to eq([@role])
      end

      it "non-matching when current account nil" do
        Account.current = nil
        conds = {updater_id: @user.id}
        expect(Core::Role.find_mine(conds)).to eq([])
      end

      it "non-matching by super admin id" do
        super_admin = create(:superadmin_user)
        conds = {updater_id: super_admin.id}
        expect(Core::Role.find_mine(conds)).to eq([])
      end
    end
  end

  context "return association Core::UserRole count" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @role_cs = create(:core_role, name: "客服", account: @account, updater: @jos, deleter_id: 0)
      @role_op = create(:core_role, name: "运营", account: @account, updater: @jos, deleter_id: 0)
      @jos_cs = create(:core_user_role, account: @account, user: @jos, role: @role_cs, updater: @jos, deleter_id: 0)
      @alex_cs = create(:core_user_role, account: @account, user: @alex, role: @role_cs, updater: @jos, deleter: @jos)
      Account.current = @account
    end

    it "return role_cs active Core::UserRole count" do
      expect(@role_cs.user_count).to eq(1)
    end

    it "return role_op active Core::UserROle count" do
      expect(@role_op.user_count).to eq(0)
    end
  end

  context "save association permissions when create or update core_role" do
    before :each do
      @account = create(:brandy_account)
      Account.current = @account
      @jos = create(:user, name: "jos")
      User.current = @jos

      @pmt_read_trade = create(:trade_read_permission, updater: @jos)
      @pmt_update_trade = create(:trade_update_permission, updater: @jos)

      pmt_ids = [@pmt_read_trade.id]
      @role_cs = create(:core_role, name: "客服", account: @account, updater: @jos, deleter_id: 0, permisson_ids: pmt_ids)
    end

    it "related empty when permisson_ids is empty by create" do
      role_op = create(:core_role, name: "运营", account: @account, updater: @jos, deleter_id: 0)
      expect(role_op.role_permissions.map(&:permission_id)).to eq([])
    end

    it "related Core::RolePermission when permisson_ids is empty by create" do
      expect(@role_cs.role_permissions.map(&:permission_id)).to eq([@pmt_read_trade.id])
    end

    it "related empty when permisson_ids is not a array by create" do
      role_op = create(:core_role, name: "运营", account: @account, updater: @jos, deleter_id: 0, permisson_ids: @pmt_read_trade.id)
      expect(role_op.role_permissions.map(&:permission_id)).to eq([])
    end

    it "not change when permission_ids is not change too by update" do
      pmt_ids = [@pmt_read_trade.id]
      @role_cs.update(name: "客服主管", account: @account, updater: @jos, deleter_id: 0, permisson_ids: pmt_ids)
      @role_cs.reload
      expect(@role_cs.role_permissions.map(&:permission_id)).to eq(pmt_ids)
    end

    it "only add new permission when permisson_ids is a right array by update" do
      pmt_ids = [@pmt_read_trade.id, @pmt_update_trade.id]
      @role_cs.update(name: "客服主管", account: @account, updater: @jos, deleter_id: 0, permisson_ids: pmt_ids)
      @role_cs.reload
      expect(@role_cs.role_permissions.map(&:permission_id)).to eq(pmt_ids)
    end

    it "delete old permission when old ids not in permission_ids by update" do
      pmt_ids = [@pmt_update_trade.id]
      @role_cs.update(name: "客服主管", account: @account, updater: @jos, deleter_id: 0, permisson_ids: pmt_ids)
      @role_cs.reload
      expect(@role_cs.role_permissions.map(&:permission_id)).to eq(pmt_ids)
    end

    it "delete old permission when permission_ids is a empty array by update" do
      pmt_ids = []
      @role_cs.update(name: "客服主管", account: @account, updater: @jos, deleter_id: 0, permisson_ids: pmt_ids)
      @role_cs.reload
      expect(@role_cs.role_permissions.map(&:permission_id)).to eq(pmt_ids)
    end

    it "skip if permisson_ids is a string by update" do
      pmt_ids = [@pmt_read_trade.id, @pmt_update_trade.id].join(",")
      old_pmt_ids = @role_cs.role_permissions.map(&:permission_id)
      @role_cs.update(name: "客服主管", account: @account, updater: @jos, deleter_id: 0, permisson_ids: pmt_ids)
      @role_cs.reload
      expect(@role_cs.role_permissions.map(&:permission_id)).to eq(old_pmt_ids)
    end

    it "skip if permisson_ids is a empty string by update" do
      pmt_ids = [@pmt_read_trade.id, @pmt_update_trade.id].join(",")
      old_pmt_ids = @role_cs.role_permissions.map(&:permission_id)
      @role_cs.update(name: "客服主管", account: @account, updater: @jos, deleter_id: 0, permisson_ids: pmt_ids)
      @role_cs.reload
      expect(@role_cs.role_permissions.map(&:permission_id)).to eq(old_pmt_ids)
    end
  end
end
