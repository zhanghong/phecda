# encoding: utf-8
require 'spec_helper'

describe Core::StockBill do
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
      let(:pro_bj) {create(:tb_pro_beijing, parent: nil)}
      let(:city_bj) {create(:tb_city_beijing, parent: pro_bj)}
      let(:state_chaoyang) {create(:tb_state_bj_chaoyang, parent: city_bj)}
      let(:core_stock) {create(:stock_default, account: account, updater: user, deleter_id: 0)}
      let(:delete_core_stock_bill) {create(:core_stock_bill, identifier: "ID12345678", stock: core_stock, area: state_chaoyang, cat_name: "bill类型名", 
                                          customer_name: "customer name", address: "detail address", account: account, updater: user, deleter: user)}
      let(:core_stock_bill) {create(:core_stock_bill, identifier: "ID12345678", stock: core_stock, area: state_chaoyang, cat_name: "bill类型名", 
                                          customer_name: "customer name", address: "detail address", account: account, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(core_stock_bill.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          core_stock_bill.update(updater_id: 0)
          expect(core_stock_bill.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          core_stock_bill.destroy
          expect(core_stock_bill.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(core_stock_bill.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          core_stock_bill.destroy
          expect(core_stock_bill.deleter_id).to eq(user.id)
          expect(core_stock_bill.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Core::StockBill.find_by_id(core_stock_bill.id)).to eq(core_stock_bill)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          core_stock_bill.destroy
          expect(Core::StockBill.find_by_id(core_stock_bill.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          core_stock_bill.destroy
          expect(Core::StockBill.find_by_id(core_stock_bill.id)).to eq(nil)
        end
      end
    end
  end

  context "belongs to association" do
    [:area, :stock, :logistic, :trade].each do |name|
      it { should belong_to(name)}
    end
  end

  context "has many association with dependent" do
    [:bill_products].each do |name|
      it { should have_many(name).dependent(:destroy)}
    end
  end

  context "has many association without dependent" do
    [:logs].each do |name|
      it { should have_many(name)}
    end
  end

  [
    {:name => :identifier, :maximum => 30},
    {:name => :customer_name, :maximum => 30},
    {:name => :address, :maximum => 100},
    {:name => :stock_id},
    {:name => :area_id},
    {:name => :cat_name},
    {:name => :stock_id}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "filter find mine method" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @pro_bj = create(:tb_pro_beijing, parent: nil)
      @city_bj = create(:tb_city_beijing, parent: @pro_bj)
      @state_chaoyang = create(:tb_state_bj_chaoyang, parent: @city_bj)
      @core_stock = create(:stock_default, account:@account, updater: @jos, deleter_id: 0)
      @delete_core_stock_bill = create(:core_stock_bill, identifier: "ID12345678", stock: @core_stock, area: @state_chaoyang, cat_name: "bill类型名", 
                                          customer_name: "customer name", address: "detail address", account: @account, updater: @jos, deleter: @jos,
                                          trade_id: 10, state: "created", mobile: "18612345678", phone: "85803298", remark: "this is remark")
      @core_stock_bill = create(:core_stock_bill, identifier: "ID12345678", stock: @core_stock, area: @state_chaoyang, cat_name: "bill类型名", 
                                          customer_name: "customer name", address: "detail address", account: @account, updater: @jos, deleter_id: 0,
                                          trade_id: 10, state: "created", mobile: "18612345678", phone: "85803298", remark: "this is remark")
      Account.current = @account
    end

    context "find by customer name" do
      it "matching by keyword customer" do
        conds = {customer_name: "customer"}
        expect(Core::StockBill.find_mine(conds)).to eq([@core_stock_bill])
      end

      it "non-matching by keyword empty" do
        conds = {customer_name: "empty"}
        expect(Core::StockBill.find_mine(conds)).to eq([])
      end
    end

    context "find by customer mobile" do
      it "matching by keyword 186123456" do
        conds = {mobile: "186123456"}
        expect(Core::StockBill.find_mine(conds)).to eq([@core_stock_bill])
      end

      it "non-matching by keyword 98245" do
        conds = {mobile: "98245"}
        expect(Core::StockBill.find_mine(conds)).to eq([])
      end
    end

    context "find by customer address" do
      it "matching by keyword address" do
        conds = {address: "address"}
        expect(Core::StockBill.find_mine(conds)).to eq([@core_stock_bill])
      end

      it "non-matching by keyword myaddress" do
        conds = {address: "myaddress"}
        expect(Core::StockBill.find_mine(conds)).to eq([])
      end
    end

    context "find by customer phone" do
      it "matching by keyword 858032" do
        conds = {phone: "858032"}
        expect(Core::StockBill.find_mine(conds)).to eq([@core_stock_bill])
      end

      it "non-matching by keyword 1112" do
        conds = {phone: "1112"}
        expect(Core::StockBill.find_mine(conds)).to eq([])
      end
    end

    context "find by customer remark" do
      it "matching by keyword mark" do
        conds = {remark: "mark"}
        expect(Core::StockBill.find_mine(conds)).to eq([@core_stock_bill])
      end

      it "non-matching by keyword myaddress" do
        conds = {remark: "mkar"}
        expect(Core::StockBill.find_mine(conds)).to eq([])
      end
    end

    context "find by related trade id" do
      it "matching by trade_id 10" do
        conds = {trade_id: 10}
        expect(Core::StockBill.find_mine(conds)).to eq([@core_stock_bill])
      end

      it "non-matching by trade_id 9" do
        conds = {trade_id: 9}
        expect(Core::StockBill.find_mine(conds)).to eq([])
      end
    end

    context "find by bill cat_name" do
      it "matching by cat_name bill类型名" do
        conds = {cat_name: "bill类型名"}
        expect(Core::StockBill.find_mine(conds)).to eq([@core_stock_bill])
      end

      it "non-matching by cat_name keyword 类型名" do
        conds = {cat_name: "类型名"}
        expect(Core::StockBill.find_mine(conds)).to eq([])
      end
    end

    context "find by bill state" do
      it "matching by state created" do
        conds = {state: "created"}
        expect(Core::StockBill.find_mine(conds)).to eq([@core_stock_bill])
      end

      it "non-matching by state audited" do
        conds = {state: "audited"}
        expect(Core::StockBill.find_mine(conds)).to eq([])
      end
    end
  end

  context "check shown attributes" do
    it "check list page view attributs" do
      arr = %w(identifier type_name cat_name_zh state_name updater_name updated_at)
      expect(Core::StockBill.list_shown_attributes).to eq(arr)
    end

    it "check show page view attributes" do
      arr = %w(identifier type_name stock_name cat_name_zh state_name customer_name area_id address mobile phone remark updater_name updated_at)
      expect(Core::StockBill.detail_shown_attributes).to eq(arr)
    end
  end

  context "Core::StockBill instance object methods" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @pro_bj = create(:tb_pro_beijing, parent: nil)
      @city_bj = create(:tb_city_beijing, parent: @pro_bj)
      @state_chaoyang = create(:tb_state_bj_chaoyang, parent: @city_bj)
      @core_stock = create(:stock_default, account:@account, updater: @jos, deleter_id: 0)
      @core_stock_bill = create(:core_stock_bill, identifier: "ID12345678", stock: @core_stock, area: @state_chaoyang, cat_name: "bill类型名", 
                                          customer_name: "customer name", address: "detail address", account: @account, updater: @jos, deleter_id: 0,
                                          trade_id: 10, state: "created", mobile: "18612345678", phone: "85803298", remark: "this is remark")
    end

    [
      {event_name: :do_audit, froms: %w(created), target: "audited"},
      {event_name: :do_stock, froms: %w(audited), target: "stocked"},
      {event_name: :do_cancel, froms: %w(created audited), target: "canceled"}
    ].each do |state_item|
      event_name = state_item[:event_name]
      from_states = state_item[:froms]
      target_state = state_item[:target]
      column_name = state_item[:column_name] || "state"
      context "return #{@property_color.class.name} #{event_name} to state #{target_state}" do
        from_states.each do |current_state|
          it "event: #{event_name} from #{current_state} to #{target_state}" do
            @core_stock_bill.update({column_name => current_state})
            expect(@core_stock_bill.send(event_name.to_s)).to eq(true)
            expect(@core_stock_bill.send("#{target_state}?")).to eq(true)
          end
        end
      end
    end

    context "return instance state name" do
      Core::StockBill::STATES.each do |state_item|
        zh_name, db_name = state_item
        it "return #{zh_name}" do
          @core_stock_bill.update(state: db_name)
          expect(@core_stock_bill.state_name).to eq(zh_name)
        end
      end
    end

    context "return instance related core stock instances name" do
      it "return related core stock name when is's present" do
        expect(@core_stock_bill.stock_name).to eq(@core_stock.name)
      end

      it "return related category name when related category destroy" do
        @core_stock.destroy
        expect(@core_stock_bill.stock_name).to eq(@core_stock.name)
      end

      it "return nil when related category is nil" do
        @core_stock_bill.update(stock_id: 0)
        expect(@core_stock_bill.stock_name).to eq(nil)
      end
    end
  end
end