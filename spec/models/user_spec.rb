# encoding: utf-8
require 'spec_helper'

describe User do
	before do
		@admin = FactoryGirl.build(:user)
	end

	context "valid user name" do
		it "user name is empty" do
			@admin.name = ""
			@admin.should_not be_valid
			@admin.errors[:name].should include("不能为空", "过短（最短为 3 个字符）")
		end

		it "user name is too short" do
			@admin.name = "a" * 2
			@admin.should_not be_valid
			@admin.errors[:name].should include("过短（最短为 3 个字符）")
		end

		it "user name is too long" do
			@admin.name = "a" * 17
			@admin.should_not be_valid
			@admin.errors[:name].should include("过长（最长为 16 个字符）")
		end

		it "user name is present" do
			user = @admin.dup
			user.save
			@admin.should_not be_valid
			@admin.errors[:name].should include("已经被使用")
		end

		it "user name is valid" do
			@admin.name = "a" * 3
			@admin.should be_valid
		end

		it "user name is valid" do
			@admin.name = "a" * 16
			@admin.should be_valid
		end
	end

	context "valid user email" do
		it "user email is empty" do
			@admin.email = ""
			@admin.should_not be_valid
			@admin.errors[:email].should include("不能为空")
		end

		it "user email is a bad format" do
			@admin.email = "a"
			@admin.should_not be_valid
			@admin.errors[:email].should include("是无效的")

			@admin.email = "aaa@134"
			@admin.should_not be_valid
			@admin.errors[:email].should include("是无效的")
		end

		it "user email is present" do
			user = @admin.dup
			user.save
			@admin.should_not be_valid
			@admin.errors[:email].should include("已经被使用")
		end

		it "user name is valid" do
			@admin.name = "test@test.com"
			@admin.should be_valid
		end
	end

	context "valid user password" do
		it "user password is empty" do
			@admin.password = ""
			@admin.should_not be_valid
			@admin.errors[:password].should include("不能为空")
		end

		it "user password is too short" do
			@admin.password = "a" * 5
			@admin.should_not be_valid
			@admin.errors[:password].should include("过短（最短为 6 个字符）")
		end

		it "user password is too long" do
			@admin.password = "a" * 21
			@admin.should_not be_valid
			@admin.errors[:password].should include("过长（最长为 20 个字符）")
		end

		it "user password is valid" do
			@admin.password = "a" * 6
			@admin.should be_valid
		end

		it "user password is valid" do
			@admin.password = "a" * 20
			@admin.should be_valid
		end
	end
end