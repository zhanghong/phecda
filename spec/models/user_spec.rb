# encoding: utf-8
require 'spec_helper'

describe User do

	context "has and belongs to many accounts" do
		it { should have_and_belong_to_many(:accounts)}
	end

	context "has_many association with dependent" do
    [:core_user_roles].each do |name|
      it { should have_many(name).dependent(:destroy)}
    end
  end

	context "has_many roles through core_user_roles" do
    it {should have_many(:roles).through(:core_user_roles)}
  end

  context "valid user name" do
	  it { should validate_presence_of(:name).with_message("不能为空")}
	  it { should validate_uniqueness_of(:name).with_message("已经被使用")}
	  it { should ensure_length_of(:name).is_at_least(3).with_message("过短（最短为 3 个字符）")}
	  it { should ensure_length_of(:name).is_at_most(16).with_message("过长（最长为 16 个字符）")}
	end

	context "valid user email" do
		let(:user) { create(:user) }

		it { should validate_presence_of(:email).with_message("不能为空")}
	  it { should validate_uniqueness_of(:email).with_message("已经被使用")}
		it "user email is a bad format" do
			user.email = "a"
			user.should_not be_valid
			user.errors[:email].should include("是无效的")

			user.email = "aaa@134"
			user.should_not be_valid
			user.errors[:email].should include("是无效的")
		end

		it "user name is valid" do
			user.name = "test@test.com"
			user.should be_valid
		end
	end

	context "valid user password" do
	  it { should validate_presence_of(:password).with_message("不能为空")}
	  it { should ensure_length_of(:password).is_at_least(6).with_message("过短（最短为 6 个字符）")}
	  it { should ensure_length_of(:password).is_at_most(20).with_message("过长（最长为 20 个字符）")}
	end

	context "set and read class current" do
		let(:user) { create(:user) }

		it "class current is nil when not set" do
			User.current = nil
			expect(User.current).to eq(nil)
		end

		it "class current is a User object when set" do
			User.current = user
			User.current
			expect(User.current).to eq(user)
		end
	end

	context "read current user id" do
		let(:user) { create(:user) }

		it "is -1 when User.current is nil" do
			User.current = nil
			expect(User.current_id).to eq(-1)
		end

		it "is User.current id" do
			User.current = user
			expect(User.current_id).to eq(user.id)
		end
	end

	context "add a account to superadmin users" do
		it "add a account to superadmin users" do
			user = create(:user)
			superadmin = create(:superadmin_user)
			account = create(:account)
			User.add_account_to_superadmins(account)
			expect(user.accounts).to 	eq([])
			expect(superadmin.accounts).to eq([account])
		end
	end

	# context "find with authentication" do
	# 	let(:user) { create(:user, email: "test@test.com", name: "Tom", password: "123456")}
	# 	it "can find when only with right user name" do
	# 		conds = {email: "Tom"}
	# 		expect(User.find_for_authentication(conds)).to eq(user)
	# 	end

	# 	# it "can find when with right user name and password" do
	# 	# 	conds = {email: "Tom", password: "123456"}
	# 	# 	expect(User.find_for_authentication(conds)).to eq(user)
	# 	# end

	# 	it "can not find only with wrong name" do
	# 		conds = {email: "test"}
	# 		expect(User.find_for_authentication(conds)).to eq(nil)
	# 	end

	# 	it "can find when only with right user email" do
	# 		conds = {email: "test@test.com"}
	# 		expect(User.find_for_authentication(conds)).to eq(user)
	# 	end

	# 	# it "can find when with right user email and password" do
	# 	# 	conds = {email: "test@test.com", password: "123456"}
	# 	# 	expect(User.find_for_authentication(conds)).to eq(user)
	# 	# end

	# 	it "can not find only with wrong email" do
	# 		conds = {email: "test@test.cn"}
	# 		expect(User.find_for_authentication(conds)).to eq(nil)
	# 	end

	# 	it "can not find when condition is a empty hash" do
	# 		conds = {}
	# 		expect(User.find_for_authentication(conds)).to eq(nil)
	# 	end
	# end

	context "user is a superadmin" do
		it "return false when is a normal user" do
			user = create(:user)
			expect(user.is_superadmin?).to eq(false)
		end

		it "return ture when is a superadmin user" do
			user = create(:superadmin_user)
			expect(user.is_superadmin?).to eq(true)
		end
	end

	context "get association permissions" do
		# let(:user) {create(:user)}
		# let(:super_admin) {create(:superadmin_user)}
		# let(:account) {create(:account)}
		# let(:role) {create(:core_role, account: account)}
		# let(:permission) {create(:admin_permission, updater: user)}
		# let(:core_user_role) {create(:core_user_role, account: account, user: user, role: role)}
		# let(:core_role_permission) {create(:core_role_permission, account: account, role: role, permission: permission, updater: user)}
		# it "retrun association permissions" do
		# 	expect(user.permissions).to eq([permission])
		# end
	end
end