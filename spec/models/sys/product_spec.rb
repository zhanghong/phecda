# encoding: utf-8
require 'spec_helper'

describe Sys::Product do
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
      let(:delete_sys_product) {create(:sys_product, category: sys_category, account: account, updater: user, deleter: user)}
      let(:sys_product) {create(:sys_product, category: sys_category, account: account, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(sys_product.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          sys_product.update(updater_id: 0)
          expect(sys_product.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          sys_product.destroy
          expect(sys_product.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(sys_product.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          sys_product.destroy
          expect(sys_product.deleter_id).to eq(user.id)
          expect(sys_product.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Sys::Product.find_by_id(sys_product.id)).to eq(sys_product)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          sys_product.destroy
          expect(Sys::Product.find_by_id(sys_product.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          sys_product.destroy
          expect(Sys::Product.find_by_id(sys_product.id)).to eq(nil)
        end
      end
    end
  end

  context "belongs to association" do
    [:category].each do |name|
      it { should belong_to(name)}
    end
  end

  context "has many association with dependent" do
    [:skus].each do |name|
      it { should have_many(name).dependent(:destroy)}
    end
  end

  [
    {:name => :title, :uniqueness => {scoped: :account_id}, :maximum => 100},
    {:name => :state}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "validate price is between  0 and 999999.99" do
    it {should validate_numericality_of(:price).is_greater_than_or_equal_to(0).is_less_than(999999.99)}
  end

  context "filter find mine method" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @sys_category = create(:sys_category, account: @account, updater: @jos, deleter_id: 0)
      @delete_sys_product = create(:sys_product, title: "已删除商品", category: @sys_category, account: @account, updater: @jos, deleter: @jos)
      @sys_product = create(:sys_product, title: "测试sys商品", category: @sys_category, account: @account, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    context "find by product title" do
      it "matching by title sys" do
        conds = {title: "sys"}
        expect(Sys::Product.find_mine(conds)).to eq([@sys_product])
      end

      it "non-matching by title keyword 删除" do
        conds = {title: "删除"}
        expect(Sys::Product.find_mine(conds)).to eq([])
      end
    end

    context "find by product id" do
      it "matching by @sys_product's id" do
        conds = {id: @sys_product.id}
        expect(Sys::Product.find_mine(conds)).to eq([@sys_product])
      end

      it "non-matching by @delete_sys_product's id" do
        conds = {id: @delete_sys_product.id}
        expect(Sys::Product.find_mine(conds)).to eq([])
      end
    end

    context "find by related category id" do
      it "matching by @sys_category's id" do
        conds = {category_id: @sys_category.id}
        expect(Sys::Product.find_mine(conds)).to eq([@sys_product])
      end

      it "non-matching by new sys category id" do
        @new_sys_category = create(:sys_category, name: "new category", account: @account, updater: @jos, deleter_id: 0)
        conds = {category_id: @new_sys_category.id}
        expect(Sys::Product.find_mine(conds)).to eq([])
      end
    end

    context "find by product state" do
      it "matching by state activted" do
        conds = {state: "activted"}
        expect(Sys::Product.find_mine(conds)).to eq([@sys_product])
      end

      it "non-matching by state hidden" do
        conds = {state: "hidden"}
        expect(Sys::Product.find_mine(conds)).to eq([])
      end
    end
  end

  context "check shown attributes" do
    it "check list page view attributs" do
      arr = %w(title price num state_name updater_name)
      expect(Sys::Product.list_shown_attributes).to eq(arr)
    end

    it "check show page view attributes" do
      arr = %w(title category_name num state_name price updater_name created_at updated_at)
      expect(Sys::Product.detail_shown_attributes).to eq(arr)
    end
  end

  context "Sys::Product instance object methods" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @sys_category = create(:sys_category, account: @account, updater: @jos, deleter_id: 0)
      @sys_product = create(:sys_product, title: "测试sys商品", category: @sys_category, account: @account, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    [
      {event_name: :active, froms: %w(hidden), target: "activted"},
      {event_name: :hide, froms: %w(activted), target: "hidden"}
    ].each do |state_item|
      event_name = state_item[:event_name]
      from_states = state_item[:froms]
      target_state = state_item[:target]
      column_name = state_item[:column_name] || "state"
      context "return #{@property_color.class.name} #{event_name} to state #{target_state}" do
        from_states.each do |current_state|
          it "event: #{event_name} from #{current_state} to #{target_state}" do
            @sys_product.update({column_name => current_state})
            expect(@sys_product.send(event_name.to_s)).to eq(true)
            expect(@sys_product.send("#{target_state}?")).to eq(true)
          end
        end
      end
    end

    context "return instance state name" do
      it "return 启用" do
        expect(@sys_product.state_name).to eq("有效")
      end

      it "return 隐藏" do
        @sys_product.hide
        expect(@sys_product.state_name).to eq("隐藏")
      end
    end

    context "return instance related sys category instances name" do
      it "return related category name when is's present" do
        expect(@sys_product.category_name).to eq(@sys_category.name)
      end

      it "return related category name when related category destroy" do
        @sys_category.destroy
        expect(@sys_product.category_name).to eq(@sys_category.name)
      end

      it "return nil when related category is nil" do
        @sys_product.category = nil
        expect(@sys_product.category_name).to eq(nil)
      end
    end
  end
end