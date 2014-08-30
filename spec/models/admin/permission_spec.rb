# encoding: utf-8
require 'spec_helper'

describe Admin::Permission do
  context "belongs to association" do
    [:updater, :deleter].each do |name|
      it { should belong_to(name)}
    end
  end

  context "has many association with dependent" do
    [:account_permissions, :role_permissions].each do |name|
      it { should have_many(name).dependent(:destroy)}
    end
  end

  context "has many accounts through account_permissions" do
    it { should have_many(:accounts).through(:account_permissions)}
  end

  context "has many roles through role_permissions" do
    it { should have_many(:roles).through(:role_permissions)}
  end

  [
    {name: :module_name, maximum: 20, uniqueness: false},
    {name: :group_name, maximum: 20, uniqueness: false},
    {name: :level, maximum: 20, uniqueness: false},
    {name: :name, maximum: 20, uniqueness: false},
    {name: :tag_name, maximum: 40, uniqueness: true},
    {name: :full_name, maximum: 30, uniqueness: true},
    {name: :subject_class, maximum: 20, uniqueness: false},
    {name: :action_name, maximum: 20, uniqueness: false}
  ].each do |valid_object|
    context "valid permission #{valid_object[:name]}" do
      name = valid_object[:name]
      maximum = valid_object[:maximum]
      it { should validate_presence_of(name).with_message("不能为空")}
      it { should ensure_length_of(name).is_at_most(maximum).with_message("过长（最长为 #{maximum} 个字符）")}
      if valid_object[:uniqueness]
        it { should validate_uniqueness_of(name).with_message("已经被使用")}
      end
    end
  end

  context "valid permission sort_num numericality" do
    it { should validate_numericality_of(:sort_num).is_greater_than(0)}
  end

  context "filter find mine method" do
    let(:user) {create(:user)}
    let(:read_trade) {create(:trade_read_permission, updater: user)}
    let(:update_trade) {create(:trade_update_permission, updater: user)}
    let(:read_seller) {create(:seller_read_permission, updater: user)}
    let(:deleted_permission) {create(:deleted_permission, updater: user)}

    context "find by full_name" do
      it "matching by full_name key world 订单" do
        conds = {full_name: "订单"}
        expect(Admin::Permission.find_mine(conds)).to eq([read_trade, update_trade])
      end

      it "non-matching by full_name key world 测试" do
        conds = {full_name: "测试"}
        expect(Admin::Permission.find_mine(conds)).to eq([])
      end
    end

    context "find by module_name" do
      it "matching by module_name key world 经销商" do
        conds = {module_name: "经销商"}
        expect(Admin::Permission.find_mine(conds)).to eq([read_seller])
      end

      it "non-matching by module_name key world 测试" do
        conds = {module_name: "测试"}
        expect(Admin::Permission.find_mine(conds)).to eq([])
      end
    end

    context "find by group_name" do
      it "matching by group_name key world 可查看" do
        conds = {group_name: "可查看"}
        expect(Admin::Permission.find_mine(conds)).to eq([read_trade, read_seller])
      end

      it "non-matching by module_name key world 测试" do
        conds = {group_name: "测试"}
        expect(Admin::Permission.find_mine(conds)).to eq([])
      end
    end

    context "find by subject_class" do
      it "matching by subject_class Trade" do
        conds = {subject_class: "Trade"}
        expect(Admin::Permission.find_mine(conds)).to eq([read_trade, update_trade])
      end

      it "non-matching by subject_class SubjectClass" do
        conds = {subject_class: "SubjectClass"}
        expect(Admin::Permission.find_mine(conds)).to eq([])
      end   
    end

    context "find by action_name" do
      it "matching by action_name read" do
        conds = {action_name: "read"}
        expect(Admin::Permission.find_mine(conds)).to eq([read_trade, read_seller])
      end

      it "non-matching by subject_class  manage" do
        conds = {action_name: "manage"}
        expect(Admin::Permission.find_mine(conds)).to eq([])
      end
    end

    context "find by updater_id" do
      it "matching by updater id" do
        conds = {updater_id: user.id}
        expect(Admin::Permission.find_mine(conds)).to eq([read_trade, update_trade, read_seller])
      end

      it "non-matching by updater id" do
        conds = {updater_id: 0}
        expect(Admin::Permission.find_mine(conds)).to eq([])
      end
    end

    context "find by empty hash" do
      it "matching by empty hash" do
        conds = {}
        expect(Admin::Permission.find_mine(conds)).to eq([read_trade, update_trade, read_seller])
      end

      it "matching by hash value is blank" do
        conds = {full_name: "", module_name: "", group_name: "", subject_class: "", action_name: "", updater_id: ""}
        expect(Admin::Permission.find_mine(conds)).to eq([read_trade, update_trade, read_seller])
      end
    end
  end

  context "return account all permissions" do
    let(:account) {create(:account)}
    let(:user) {create(:user)}
    let(:read_trade) {create(:trade_read_permission, updater: user)}
    let(:update_trade) {create(:trade_update_permission, updater: user)}
    let(:account_read_trade_permission) {create(:admin_account_permission, account: account, permission: read_trade, updater: user)}
    let(:account_update_trade_permission) {create(:deleted_account_permission, account: account, permission: update_trade, updater: user, deleter: user)}
    it "matching account related all permission" do
      account_read_trade_permission
      account_update_trade_permission
      expect(Admin::Permission.account_all_permissions(account.id)).to eq([read_trade])
    end
  end

  context "return permission updater name" do
    it "updater id is present" do
      user = create(:user)
      read_trade = create(:trade_read_permission, updater: user)
      expect(read_trade.updater_name).to eq(user.name)
    end

    it "updater id is empty" do
      read_trade = create(:trade_read_permission, updater: nil)
      expect(read_trade.updater_name).to eq(nil)
    end
  end

  context "return permission deleter name" do
    it "deleter id is present" do
      user = create(:user)
      deleted_permission = create(:deleted_permission, updater: user, deleter: user)
      expect(deleted_permission.updater_name).to eq(user.name)
    end

    it "deleter id is empty" do
      user = create(:user)
      User.current = nil
      deleted_permission = create(:deleted_permission, updater: user, deleter: nil)
      expect(deleted_permission.deleter_name).to eq(nil)
    end
  end

  context "destroy permission" do
    it "destroy when current user is persent" do
      user = create(:user)
      User.current = user
      read_trade = create(:trade_read_permission, updater: user)
      read_trade.destroy
      expect(read_trade.deleter_id).to eq(user.id)
      expect(read_trade.deleted_at.present?).to eq(true)
    end

    it "destroy when current user is empty" do
      user = create(:user)
      User.current = nil
      read_trade = create(:trade_read_permission, updater: user)
      read_trade.destroy
      expect(read_trade.deleter_id).to eq(-1)
      expect(read_trade.deleted_at.present?).to eq(true)
    end
  end
end
