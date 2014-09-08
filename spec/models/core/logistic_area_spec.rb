require 'spec_helper'

describe Core::LogisticArea do
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
      let(:logistic_ems) {create(:logistic_ems, account: account, updater: user, deleter_id: 0)}
      let(:pro_bj) {create(:tb_pro_beijing, parent: nil)}
      let(:deleted_logistic_area) {create(:core_logistic_area, account: account, logistic: logistic_ems, area: pro_bj, updater: user, deleter: user)}
      let(:logistic_area) {create(:core_logistic_area, account: account, logistic: logistic_ems, area: pro_bj, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(logistic_area.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          logistic_area.update(updater_id: 0)
          expect(logistic_area.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          logistic_area.destroy
          expect(logistic_area.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(logistic_area.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          logistic_area.destroy
          expect(logistic_area.deleter_id).to eq(user.id)
          expect(logistic_area.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Core::LogisticArea.find_by_id(logistic_area.id)).to eq(logistic_area)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          logistic_area.destroy
          expect(Core::LogisticArea.find_by_id(logistic_area.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          logistic_area.destroy
          expect(Core::LogisticArea.find_by_id(logistic_area.id)).to eq(nil)
        end
      end
    end
  end

  context "belongs to association" do
    [:logistic, :area].each do |name|
      it { should belong_to(name)}
    end
  end

  [
    {:name => :logistic_id, :uniqueness => {scoped: :area_id}},
    {:name => :area_id, :uniqueness => {scoped: :logistic_id}}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "check shown attributes" do
    it "show attributes for core_logistic" do
      arr = %w(area_zipcode area_province_name area_city_name area_state_name)
      expect(Core::LogisticArea.inner_shown_attributes_for_core_logistic).to eq(arr)
    end

    it "show attributes for core_area" do
      arr = %w(logistic_name)
      expect(Core::LogisticArea.inner_shown_attributes_for_core_area).to eq(arr)
    end
  end

  context "filter find mine method" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @ems = create(:logistic_ems, account: @account, updater: @jos, deleter_id: 0)
      @yuantong = create(:logistic_yt, account: @account, updater: @jos, deleter_id: 0)
      @pro_bj = create(:tb_pro_beijing, parent: nil)
      @city_bj = create(:tb_city_beijing, parent: @pro_bj)
      @state_chaoyang = create(:tb_state_bj_chaoyang, parent: @city_bj)
      @state_haidian = create(:tb_state_bj_haidian, parent: @city_bj)
      @ems_chaoyang = create(:core_logistic_area, account: @account, logistic: @ems, area: @state_chaoyang, updater: @jos, deleter_id: 0)
      @ems_haidian = create(:core_logistic_area, account: @account, logistic: @ems, area: @state_haidian, updater: @jos, deleter: @jos)
      Account.current = @account
    end

    context "find by logistic name" do
      it "matching by logistic ems name" do
        conds = {logistic_name: @ems.name}
        expect(Core::LogisticArea.find_mine(conds)).to eq([@ems_chaoyang])
      end

      it "non-matching by logistic yuantong name" do
        conds = {logistic_name: @yuantong.name}
        expect(Core::LogisticArea.find_mine(conds)).to eq([])
      end
    end

    context "find by parent id" do
      it "matching by area city beijin" do
        conds = {parent_id: @city_bj.id}
        expect(Core::LogisticArea.find_mine(conds)).to eq([@ems_chaoyang])
      end

      it "non-matching by area haidian" do
        conds = {parent_id: @pro_bj.id}
        expect(Core::LogisticArea.find_mine(conds)).to eq([])
      end
    end

    context "find by area id" do
      it "matching by area chaoyang id in Array" do
        conds = {area_id: [@state_chaoyang.id]}
        expect(Core::LogisticArea.find_mine(conds)).to eq([@ems_chaoyang])
      end

      it "matching by area chaoyang id is not a array" do
        conds = {area_id: @state_chaoyang.id}
        expect(Core::LogisticArea.find_mine(conds)).to eq([@ems_chaoyang])
      end

      it "non-matching by area haidian id in Array" do
        conds = {area_id: [@state_haidian.id]}
        expect(Core::LogisticArea.find_mine(conds)).to eq([])
      end

      it "non-matching by area haidian id is not a Array" do
        conds = {area_id: @state_haidian.id}
        expect(Core::LogisticArea.find_mine(conds)).to eq([])
      end
    end

    context "find by logistic id" do
      it "matching by logistic ems id is a array" do
        conds = {logistic_id: [@ems.id]}
        expect(Core::LogisticArea.find_mine(conds)).to eq([@ems_chaoyang])
      end

      it "matching by logistic ems id is not a array" do
        conds = {logistic_id: @ems.id}
        expect(Core::LogisticArea.find_mine(conds)).to eq([@ems_chaoyang])
      end

      it "non-matching by logistic yuantong is a array" do
        conds = {logistic_id: [@yuantong.id]}
        expect(Core::LogisticArea.find_mine(conds)).to eq([])
      end

      it "non-matching by logistic yuantong is not a array" do
        conds = {logistic_id: @yuantong.id}
        expect(Core::LogisticArea.find_mine(conds)).to eq([])
      end
    end

    context "find by updater id" do
      it "matching by update user jos" do
        conds = {updater_id: @jos.id}
        expect(Core::LogisticArea.find_mine(conds)).to eq([@ems_chaoyang])
      end

      it "non-matching by update user alex" do
        conds = {updater_id: @alex.id}
        expect(Core::LogisticArea.find_mine(conds)).to eq([])
      end
    end
  end

  context "related area children when binding or unbinding area nodel " do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @ems = create(:logistic_ems, account: @account, updater: @jos, deleter_id: 0)
      @pro_bj = create(:tb_pro_beijing, parent: nil)
      @city_bj = create(:tb_city_beijing, parent: @pro_bj)
      @state_chaoyang = create(:tb_state_bj_chaoyang, parent: @city_bj)
      @state_haidian = create(:tb_state_bj_haidian, parent: @city_bj)
      @ems_haidian = create(:core_logistic_area, account: @account, logistic: @ems, area: @state_haidian, updater: @jos, deleter: @jos)
      Account.current = @account
    end

    it "binding beijing province" do
      Core::LogisticArea.check_node(@ems.id, @pro_bj.id, true)
      expect(Core::LogisticArea.count).to eq(4)
    end

    it "un-binding beijing province" do
      Core::LogisticArea.check_node(@ems.id, @pro_bj.id, true)
      Core::LogisticArea.check_node(@ems.id, @pro_bj.id, false)
      expect(Core::LogisticArea.count).to eq(0)
    end
  end

  context "check object method methods" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @ems = create(:logistic_ems, account: @account, updater: @jos, deleter_id: 0)
      @pro_bj = create(:tb_pro_beijing, parent: nil)
      @city_bj = create(:tb_city_beijing, parent: @pro_bj)
      @state_chaoyang = create(:tb_state_bj_chaoyang, parent: @city_bj)
      @ems_chaoyang = create(:core_logistic_area, account: @account, logistic: @ems, area: @state_chaoyang, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    it "return related logistic name" do
      expect(@ems_chaoyang.logistic_name).to eq(@ems.name)
    end

    it "return related area zip code" do
      expect(@ems_chaoyang.area_zipcode).to eq(@state_chaoyang.zipcode)
    end

    it "return related area province name" do
      expect(@ems_chaoyang.area_province_name).to eq(@state_chaoyang.province_name)
    end

    it "return related area city name" do
      expect(@ems_chaoyang.area_city_name).to eq(@state_chaoyang.city_name)
    end

    it "return related area state name" do
      expect(@ems_chaoyang.area_state_name).to eq(@state_chaoyang.state_name)
    end
  end
end
