# encoding: utf-8
require 'spec_helper'

describe Sys::Category do
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
      let(:delete_category) {create(:sys_category, account: account, updater: user, deleter: user)}
      let(:sys_category) {create(:sys_category, account: account, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(sys_category.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          sys_category.update(updater_id: 0)
          expect(sys_category.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          sys_category.destroy
          expect(sys_category.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(sys_category.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          sys_category.destroy
          expect(sys_category.deleter_id).to eq(user.id)
          expect(sys_category.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Sys::Category.find_by_id(sys_category.id)).to eq(sys_category)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          sys_category.destroy
          expect(Sys::Category.find_by_id(sys_category.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          sys_category.destroy
          expect(Sys::Category.find_by_id(sys_category.id)).to eq(nil)
        end
      end
    end
  end

  context "has many association with dependent" do
    [:category_properties].each do |name|
      it { should have_many(name).dependent(:destroy)}
    end
  end

  context "has many through" do
    it "have many properties through category_properties" do
      it {should have_many(:properties).through(:category_properties)}
    end
  end

  [
    {:name => :name, :uniqueness => {scoped: :account_id}, :maximum => 20},
    {:name => :state}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "filter find mine method" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @deleted_category = create(:sys_category, name: "color", account: @account, updater: @jos, deleter: @jos)
      @category_color = create(:sys_category, name: "color", account: @account, updater: @jos, deleter_id: 0)
      @category_CL755 = create(:sys_category, name: "color_755", account: @account, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    context "find by category name" do
      it "matching by name color" do
        conds = {name: "color"}
        expect(Sys::Category.find_mine(conds)).to eq([@category_color, @category_CL755])
      end

      it "non-matching by name keyword size" do
        conds = {name: "size"}
        expect(Sys::Category.find_mine(conds)).to eq([])
      end
    end

    context "find by category parent id" do
      it "matching by @category_color id" do
        conds = {parent_id: @category_color.id}
        expect(Sys::Category.find_mine(conds)).to eq([@category_CL755])
      end

      it "non-matching by @category_CL755 id" do
        conds = {parent_id: @category_CL755.id}
        expect(Sys::Category.find_mine(conds)).to eq([])
      end
    end

    context "find by category state" do
      it "matching by state activted" do
        conds = {state: "actived"}
        expect(Sys::Category.find_mine(conds)).to eq([@category_color])
      end

      it "non-matching by state hidden" do
        conds = {state: "hidden"}
        expect(Sys::Category.find_mine(conds)).to eq([])
      end
    end
  end

  context "check shown attributes" do
    it "check list page view attributs" do
      arr = %w(name status_name parent_name created_at updated_at)
      expect(Sys::Category.list_shown_attributes).to eq(arr)
    end

    it "check show page view attributes" do
      arr = %w(name status_name created_at updated_at parent_name children_name properties_name)
      expect(Sys::Category.detail_shown_attributes).to eq(arr)
    end
  end

  context "Core::Seller instance object methods" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @category_color = create(:sys_category, name: "color", account: @account, updater: @jos, deleter_id: 0)
      @category_CL755 = create(:sys_category, name: "color_755", account: @account, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    [
      {event_name: :active, froms: %w(hidden), target: "actived"},
      {event_name: :hide, froms: %w(actived), target: "hidden"}
    ].each do |state_item|
      event_name = state_item[:event_name]
      from_states = state_item[:froms]
      target_state = state_item[:target]
      column_name = state_item[:column_name] || "state"
      context "return #{@category_color.class.name} #{event_name} to state #{target_state}" do
        from_states.each do |current_state|
          it "event: #{event_name} from #{current_state} to #{target_state}" do
            @category_color.update({column_name => current_state})
            expect(@category_color.send(event_name.to_s)).to eq(true)
            expect(@category_color.send("#{target_state}?")).to eq(true)
          end
        end
      end
    end

    context "return instance state name" do
      it "return 启用" do
        expect(@category_color.state_name).to eq("启用")
      end

      it "return 隐藏" do
        @category_color.hide
        expect(@category_color.state_name).to eq("隐藏")
      end
    end

    context "return instance parent name" do
      it "@category_CL755's parent name is @category_color.name " do
        expect(@category_CL755.parent_name).to eq(@category_color.name)
      end

      it "return nil if instance's parent is nil" do
        expect(@category_color.parent_name).to eq(nil)
      end
    end

    context "return instance children's name in Array" do
      it "return @category_color children's name " do
        expect(@category_color.children_name).to eq([@category_CL755.name])
      end

      it "return empty array if instance do not have children" do
        expect(@category_CL755.children_name).to eq([])
      end
    end

    context "save self category values" do
      it "save new value with skip old and empty item" do
        values_name = "red \r\n red \r\n yellow"
        @category_color.save_category_values(values_name)
        expect(@category_color.values_count).to eq(2)
        new_value = @category_color.values.last
        expect(new_value.name).to eq("yellow")
        expect(new_value.account_id).to eq(@category_color.account_id)
      end

      it "save new value and delete old item" do
        values_name = " yellow "
        @category_color.save_category_values(values_name)
        expect(@category_color.values_count).to eq(1)
        new_value = @category_color.values.last
        expect(new_value.name).to eq("yellow")
        expect(new_value.account_id).to eq(@category_color.account_id)
      end

      it "delete all old values when parameter is empty" do
        values_name = nil
        @category_color.save_category_values(values_name)
        expect(@category_color.values_count).to eq(0)
      end
    end
  end
end
