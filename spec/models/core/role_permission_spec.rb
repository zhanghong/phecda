require 'spec_helper'

describe Core::RolePermission do
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
      let(:pmt_read_trade) {create(:trade_read_permission, updater: user, deleter_id: 0)}
      let(:role_permission) {create(:core_role_permission, account: account, updater: user, deleter_id: 0, role: role, permission: pmt_read_trade)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(role_permission.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          role_permission.update(updater_id: 0)
          expect(role_permission.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          role_permission.destroy
          expect(role_permission.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(role_permission.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          role_permission.destroy
          expect(role_permission.deleter_id).to eq(user.id)
          expect(role_permission.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Core::RolePermission.find_by_id(role_permission.id)).to eq(role_permission)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          role_permission.destroy
          expect(Core::RolePermission.find_by_id(role_permission.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          role_permission.destroy
          expect(Core::RolePermission.find_by_id(role_permission.id)).to eq(nil)
        end
      end
    end
  end

  context "belongs to association" do
    [:role, :permission].each do |name|
      it { should belong_to(name)}
    end
  end
end
