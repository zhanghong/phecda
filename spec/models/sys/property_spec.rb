# encoding: utf-8
require 'spec_helper'

describe Sys::Property do
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
      let(:delete_property) {create(:sys_property, account: account, updater: user, deleter: user)}
      let(:sys_property) {create(:sys_property, account: account, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(sys_property.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          sys_property.update(updater_id: 0)
          expect(sys_property.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          sys_property.destroy
          expect(sys_property.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(sys_property.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          sys_property.destroy
          expect(sys_property.deleter_id).to eq(user.id)
          expect(sys_property.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Sys::Property.find_by_id(sys_property.id)).to eq(sys_property)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          sys_property.destroy
          expect(Sys::Property.find_by_id(sys_property.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          sys_property.destroy
          expect(Sys::Property.find_by_id(sys_property.id)).to eq(nil)
        end
      end
    end
  end

  context "has many association with dependent" do
    [:category_properties, :values].each do |name|
      it { should have_many(name).dependent(:destroy)}
    end
  end

  context "has many through" do
    it "have many categories through category_properties" do
     should have_many(:categories).through(:category_properties)
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
      @deleted_property = create(:sys_property, name: "color", account: @account, updater: @jos, deleter: @jos)
      @property_color = create(:sys_property, name: "color", account: @account, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    context "find by property name" do
      it "matching by name color" do
        conds = {name: "color"}
        expect(Sys::Property.find_mine(conds)).to eq([@property_color])
      end

      it "non-matching by name keyword size" do
        conds = {name: "size"}
        expect(Sys::Property.find_mine(conds)).to eq([])
      end
    end

    context "find by property state" do
      it "matching by state activted" do
        conds = {state: "activted"}
        expect(Sys::Property.find_mine(conds)).to eq([@property_color])
      end

      it "non-matching by state hidden" do
        conds = {state: "hidden"}
        expect(Sys::Property.find_mine(conds)).to eq([])
      end
    end
  end

  context "check shown attributes" do
    it "check list page view attributs" do
      arr = %w(name state_name values_count created_at updated_at)
      expect(Sys::Property.list_shown_attributes).to eq(arr)
    end

    it "check show page view attributes" do
      arr = %w(name state_name created_at updated_at values_name)
      expect(Sys::Property.detail_shown_attributes).to eq(arr)
    end
  end

  context "Sys::Property instance object methods" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @property_color = create(:sys_property, name: "color", account: @account, updater: @jos, deleter_id: 0)
      @pro_value_red = create(:sys_property_values, name: "red", property: @property_color, account: @account, updater: @jos, deleter_id: 0)
      @pro_value_blue = create(:sys_property_values, name: "blue", property: @property_color, account: @account, updater: @jos, deleter: @jos)
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
            @property_color.update({column_name => current_state})
            expect(@property_color.send(event_name.to_s)).to eq(true)
            expect(@property_color.send("#{target_state}?")).to eq(true)
          end
        end
      end
    end

    context "return instance related property_value instances name" do
      it "return red in a array" do
        expect(@property_color.values_name).to eq([@pro_value_red.name])
      end

      it "return empty array when pro_value_red destroy" do
        @pro_value_red.destroy
        expect(@property_color.values_name).to eq([])
      end
    end

    context "return instance related property_value instances count" do
      it "return 1" do
        expect(@property_color.values_count).to eq(1)
      end

      it "return empty array when pro_value_red destroy" do
        @pro_value_red.destroy
        expect(@property_color.values_count).to eq(0)
      end
    end

    context "return instance state name" do
      it "return 启用" do
        expect(@property_color.state_name).to eq("启用")
      end

      it "return 隐藏" do
        @property_color.hide
        expect(@property_color.state_name).to eq("隐藏")
      end
    end

    context "save self property values" do
      it "save new value with skip old and empty item" do
        values_name = "red \r\n red \r\n yellow"
        @property_color.save_property_values(values_name)
        expect(@property_color.values_count).to eq(2)
        new_value = @property_color.values.last
        expect(new_value.name).to eq("yellow")
        expect(new_value.account_id).to eq(@property_color.account_id)
      end

      it "save new value and delete old item" do
        values_name = " yellow "
        @property_color.save_property_values(values_name)
        expect(@property_color.values_count).to eq(1)
        new_value = @property_color.values.last
        expect(new_value.name).to eq("yellow")
        expect(new_value.account_id).to eq(@property_color.account_id)
      end

      it "delete all old values when parameter is empty" do
        values_name = nil
        @property_color.save_property_values(values_name)
        expect(@property_color.values_count).to eq(0)
      end
    end
  end
end
