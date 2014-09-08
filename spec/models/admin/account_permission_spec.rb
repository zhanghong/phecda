# encoding: utf-8
require 'spec_helper'

describe Admin::AccountPermission do
  context "belongs to association" do
    [:account, :permission, :updater, :deleter].each do |name|
      it { should belong_to(name)}
    end
  end

  [
    {name: :account_id}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "check shown attributes" do
    it "check list page view attributs" do
      arr = %w(account_name joined_at granted_at)
      expect(Admin::AccountPermission.list_shown_attributes).to eq(arr)
    end

    it "check show page view attributes" do
      arr = []
      expect(Admin::AccountPermission.detail_shown_attributes).to eq(arr)
    end

    it "check inner view attributes for admin permission" do
      arr = %w(account_name granted_at)
      expect(Admin::AccountPermission.inner_shown_attributes_for_admin_permission).to eq(arr)
    end
  end

  context "filter find mine method" do
    before :each do
      @user = create(:user)
      @read_trade = create(:trade_read_permission, updater: @user)
      @read_seller = create(:seller_read_permission, updater: @user)
      @deleted_permission = create(:deleted_permission, updater: @user, deleter: @user)
      @account = create(:brandy_account)
      @update_trade = create(:trade_update_permission, updater: @user)
    end

    it "matching by account_name" do
      conds = {account_name: "brand"}
      expect(Admin::AccountPermission.find_mine(conds).collect(&:permission_id)).to eq([@read_trade.id, @read_seller.id])
    end

    it "non-matching by account_name" do
      conds = {account_name: "badname"}
      expect(Admin::AccountPermission.find_mine(conds).collect(&:permission_id)).to eq([])
    end

    it "matching by permission name" do
      conds = {permission_name: "订单"}
      expect(Admin::AccountPermission.find_mine(conds).collect(&:permission_id)).to eq([@read_trade.id])
    end

    it "non-matching by permission name" do
      conds = {permission_name: "系统"}
      expect(Admin::AccountPermission.find_mine(conds).collect(&:permission_id)).to eq([])
    end

    it "matching by updater id" do
      conds = {updater_id: 0}
      expect(Admin::AccountPermission.find_mine(conds).collect(&:permission_id)).to eq([@read_trade.id, @read_seller.id])
    end

    it "non-matching by updater id" do
      conds = {updater_id: @user.id}
      expect(Admin::AccountPermission.find_mine(conds).collect(&:permission_id)).to eq([])
    end

    it "matching all when query hash is empty" do
      conds = {updater_id: "", account_name: "", permission_name: ""}
      expect(Admin::AccountPermission.find_mine(conds).collect(&:permission_id)).to eq([@read_trade.id, @read_seller.id])
    end
  end

  context "filter account group find method" do
    before :each do
      @user = create(:user)
      @read_trade = create(:trade_read_permission, updater: @user)
      @read_seller = create(:seller_read_permission, updater: @user)
      @deleted_permission = create(:deleted_permission, updater: @user, deleter: @user)
      @account = create(:brandy_account)
      @update_trade = create(:trade_update_permission, updater: @user)
      @new_account = create(:brandy_account, name: "new account")
    end

    it "matching and return group return values" do
      conds = {permission_name: "查看"}
      expect(Admin::AccountPermission.account_group_find(conds).collect(&:permission_id)).to eq([@read_trade.id, @read_trade.id])
    end

    it "non-matching return a empty array" do
      conds = {account_name: "grandadfe"}
      expect(Admin::AccountPermission.account_group_find(conds).collect(&:permission_id)).to eq([])
    end
  end

  context "return permission name" do
    let(:user) {create(:user)}
    let(:account) {create(:account)}
    let(:permission) {create(:admin_permission, updater: user)}
    let(:account_permission) {create(:admin_account_permission, updater: user, permission: permission, account: account)}

    it "return self name if self name present" do
      name = "account permission"
      account_permission.name = name
      expect(account_permission.permission_name).to eq(name)
    end

    it "return related permission name if self name blank" do
      expect(account_permission.permission_name).to eq(permission.name)
    end
  end

  context "return relate account name" do
    let(:user) {create(:user)}
    let(:account) {create(:account)}
    let(:permission) {create(:admin_permission, updater: user)}
    let(:account_permission) {create(:admin_account_permission, updater: user, permission: permission, account: account)}

    it "related account present" do
      expect(account_permission.account_name).to eq(account.name)
    end

    it "related account is empty" do
      account_permission.account_id = Account.current_id
      expect(account_permission.account_name).to eq(nil)
    end
  end

  context "return account joined time" do
    let(:user) {create(:user)}
    let(:account) {create(:account)}
    let(:permission) {create(:admin_permission, updater: user)}
    let(:account_permission) {create(:admin_account_permission, updater: user, permission: permission, account: account)}

    it "related account present" do
      expect(account_permission.joined_at).to eq(account.created_at)
    end

    it "related account is empty" do
      account_permission.account_id = Account.current_id
      expect(account_permission.joined_at).to eq(nil)
    end
  end

  context "return account granted pelivage time" do
    let(:user) {create(:user)}
    let(:account) {create(:account)}
    let(:permission) {create(:admin_permission, updater: user)}
    let(:account_permission) {create(:admin_account_permission, updater: user, permission: permission, account: account)}

    it {expect(account_permission.granted_at).to eq(account_permission.updated_at)}
  end

  context "return permission updater name" do
    let(:user) {create(:user)}
    let(:account) {create(:account)}
    let(:permission) {create(:admin_permission, updater: user)}
    let(:account_permission) {create(:admin_account_permission, updater: user, permission: permission, account: account)}

    it "updater id is present" do
      expect(account_permission.updater_name).to eq(user.name)
    end

    it "updater id is empty" do
      account_permission.updater_id = User.current_id
      expect(account_permission.updater_name).to eq(nil)
    end
  end

  context "return permission deleter name" do
    let(:user) {create(:user)}
    let(:account) {create(:account)}
    let(:permission) {create(:admin_permission, updater: user)}
    let(:account_permission) {create(:admin_account_permission, updater: user, permission: permission, account: account, deleter: user)}

    it "deleter id is present" do
      expect(account_permission.deleter_name).to eq(user.name)
    end

    it "deleter id is empty" do
      User.current = nil
      account_permission.deleter_id = User.current_id
      expect(account_permission.deleter_name).to eq(nil)
    end
  end

  context "destroy permission" do
    let(:user) {create(:user)}
    let(:account) {create(:account)}
    let(:permission) {create(:admin_permission, updater: user)}
    let(:account_permission) {create(:admin_account_permission, updater: user, permission: permission, account: account)}

    it "destroy when current user is persent" do
      User.current = user
      account_permission.destroy
      expect(account_permission.deleter_id).to eq(user.id)
      expect(account_permission.deleted_at.present?).to eq(true)
    end

    it "destroy when current user is empty" do
      User.current = nil
      account_permission.destroy
      expect(account_permission.deleter_id).to eq(-1)
      expect(account_permission.deleted_at.present?).to eq(true)
    end
  end
end
