require 'spec_helper'

describe Core::SellerArea do
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
      let(:default_stock) {create(:stock_default, account: account, updater: user, deleter_id: 0)}
      let(:seller) {create(:seller_bj, stock: default_stock, account: account, updater_id: user, parent_id: nil, deleter_id: 0)}
      let(:pro_bj) {create(:tb_pro_beijing, parent: nil)}
      let(:deleted_seller_area) {create(:core_seller_area, account: account, seller: seller, area: pro_bj, updater: user, deleter: user)}
      let(:seller_area) {create(:core_seller_area, account: account, seller: seller, area: pro_bj, updater: user, deleter_id: 0)}

      context "return updater user name" do
        it "return association user name if has updater" do
          expect(seller_area.updater_name).to eq(user.name)
        end

        it "return nil if no updater" do
          seller_area.update(updater_id: 0)
          expect(seller_area.updater_name).to eq(nil)
        end
      end

      context "return deleter user name" do
        it "return association user name if has deleter" do
          User.current = user
          seller_area.destroy
          expect(seller_area.deleter_name).to eq(user.name)
        end

        it "return nil if no deleter" do
          expect(seller_area.deleter_name).to eq(nil)
        end
      end

      context "destroy object" do
        it "rupdate deleter_id and deleted_at when destroy" do
          User.current = user
          seller_area.destroy
          expect(seller_area.deleter_id).to eq(user.id)
          expect(seller_area.deleted_at.present?).to eq(true)
        end
      end

      context "default scope" do
        it "return object when object is not destroy" do
          Account.current = account
          expect(Core::SellerArea.find_by_id(seller_area.id)).to eq(seller_area)
        end

        it "return nil when object destroy by nil user" do
          Account.current = account
          seller_area.destroy
          expect(Core::SellerArea.find_by_id(seller_area.id)).to eq(nil)
        end

        it "return nil when object destroy by current user" do
          Account.current = account
          User.current = user
          seller_area.destroy
          expect(Core::SellerArea.find_by_id(seller_area.id)).to eq(nil)
        end
      end
    end
  end

  context "belongs to association" do
    [:seller, :area].each do |name|
      it { should belong_to(name)}
    end
  end

  [
    {:name => :seller_id, :uniqueness => {scoped: :area_id}},
    {:name => :area_id, :uniqueness => {scoped: :seller_id}}
  ].each do |valid_object|
    shoulda_validate_text_field(valid_object)
  end

  context "check shown attributes" do
    it "show attributes for core_seller" do
      arr = %w(area_zipcode area_province_name area_city_name area_state_name)
      expect(Core::SellerArea.inner_shown_attributes_for_core_seller).to eq(arr)
    end

    it "show attributes for core_area" do
      arr = %w(seller_name)
      expect(Core::SellerArea.inner_shown_attributes_for_core_area).to eq(arr)
    end
  end

  context "filter find mine method" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @default_stock = create(:stock_default, account: @account, updater: @jos, deleter_id: 0)
      @bj_seller = create(:seller_bj, stock: @default_stock, account: @account, updater_id: @jos, parent_id: nil, deleter_id: 0)
      @sh_seller = create(:seller_sh, stock: @default_stock, account: @account, updater: @jos, parent_id: nil, deleter_id: 0)
      @pro_bj = create(:tb_pro_beijing, parent: nil)
      @city_bj = create(:tb_city_beijing, parent: @pro_bj)
      @state_chaoyang = create(:tb_state_bj_chaoyang, parent: @city_bj)
      @state_haidian = create(:tb_state_bj_haidian, parent: @city_bj)
      @seller_bj_chaoyang = create(:core_seller_area, account: @account, seller: @bj_seller, area: @state_chaoyang, updater: @jos, deleter_id: 0)
      @seller_bj_haidian = create(:core_seller_area, account: @account, seller: @bj_seller, area: @state_haidian, updater: @jos, deleter: @jos)
      Account.current = @account
    end

    context "find by seller name" do
      it "matching by beijing seller name" do
        conds = {seller_name: @bj_seller.name}
        expect(Core::SellerArea.find_mine(conds)).to eq([@seller_bj_chaoyang])
      end

      it "non-matching by shanghai seller name" do
        conds = {seller_name: @sh_seller.name}
        expect(Core::SellerArea.find_mine(conds)).to eq([])
      end
    end

    context "find by parent id" do
      it "matching by area city beijin" do
        conds = {parent_id: @city_bj.id}
        expect(Core::SellerArea.find_mine(conds)).to eq([@seller_bj_chaoyang])
      end

      it "non-matching by area haidian" do
        conds = {parent_id: @pro_bj.id}
        expect(Core::SellerArea.find_mine(conds)).to eq([])
      end
    end

    context "find by area id" do
      it "matching by area chaoyang id in Array" do
        conds = {area_id: [@state_chaoyang.id]}
        expect(Core::SellerArea.find_mine(conds)).to eq([@seller_bj_chaoyang])
      end

      it "matching by area chaoyang id is not a array" do
        conds = {area_id: @state_chaoyang.id}
        expect(Core::SellerArea.find_mine(conds)).to eq([@seller_bj_chaoyang])
      end

      it "non-matching by area haidian id in Array" do
        conds = {area_id: [@state_haidian.id]}
        expect(Core::SellerArea.find_mine(conds)).to eq([])
      end

      it "non-matching by area haidian id is not a Array" do
        conds = {area_id: @state_haidian.id}
        expect(Core::SellerArea.find_mine(conds)).to eq([])
      end
    end

    context "find by seller id" do
      it "matching by beijing seller id is a array" do
        conds = {seller_id: [@bj_seller.id]}
        expect(Core::SellerArea.find_mine(conds)).to eq([@seller_bj_chaoyang])
      end

      it "matching by beijing seller id is not a array" do
        conds = {seller_id: @bj_seller.id}
        expect(Core::SellerArea.find_mine(conds)).to eq([@seller_bj_chaoyang])
      end

      it "non-matching by shanghai seller is a array" do
        conds = {seller_id: [@sh_seller.id]}
        expect(Core::SellerArea.find_mine(conds)).to eq([])
      end

      it "non-matching by logistic yuantong is not a array" do
        conds = {seller_id: @sh_seller.id}
        expect(Core::SellerArea.find_mine(conds)).to eq([])
      end
    end

    context "find by updater id" do
      it "matching by update user jos" do
        conds = {updater_id: @jos.id}
        expect(Core::SellerArea.find_mine(conds)).to eq([@seller_bj_chaoyang])
      end

      it "non-matching by update user alex" do
        conds = {updater_id: @alex.id}
        expect(Core::SellerArea.find_mine(conds)).to eq([])
      end
    end
  end

  context "related area children when binding or unbinding area nodel " do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @default_stock = create(:stock_default, account: @account, updater: @jos, deleter_id: 0)
      @bj_seller = create(:seller_bj, stock: @default_stock, account: @account, updater_id: @jos, parent_id: nil, deleter_id: 0)
      @pro_bj = create(:tb_pro_beijing, parent: nil)
      @city_bj = create(:tb_city_beijing, parent: @pro_bj)
      @state_chaoyang = create(:tb_state_bj_chaoyang, parent: @city_bj)
      @state_haidian = create(:tb_state_bj_haidian, parent: @city_bj)
      @seller_bj_haidian = create(:core_seller_area, account: @account, seller: @bj_seller, area: @state_haidian, updater: @jos, deleter: @jos)
      Account.current = @account
    end

    it "binding beijing province" do
      Core::SellerArea.check_node(@bj_seller.id, @pro_bj.id, true)
      expect(Core::SellerArea.count).to eq(4)
    end

    it "un-binding beijing province" do
      Core::SellerArea.check_node(@bj_seller.id, @pro_bj.id, true)
      Core::SellerArea.check_node(@bj_seller.id, @pro_bj.id, false)
      expect(Core::SellerArea.count).to eq(0)
    end
  end

  context "check object method methods" do
    before :each do
      @account = create(:brandy_account)
      @jos = create(:user, name: "jos")
      @alex = create(:user, name: "alex")
      @default_stock = create(:stock_default, account: @account, updater: @jos, deleter_id: 0)
      @bj_seller = create(:seller_bj, stock: @default_stock, account: @account, updater_id: @jos, parent_id: nil, deleter_id: 0)
      @pro_bj = create(:tb_pro_beijing, parent: nil)
      @city_bj = create(:tb_city_beijing, parent: @pro_bj)
      @state_chaoyang = create(:tb_state_bj_chaoyang, parent: @city_bj)
      @seller_bj_chaoyang = create(:core_seller_area, account: @account, seller: @bj_seller, area: @state_chaoyang, updater: @jos, deleter_id: 0)
      Account.current = @account
    end

    it "return related logistic name" do
      expect(@seller_bj_chaoyang.seller_name).to eq(@bj_seller.name)
    end

    it "return related area zip code" do
      expect(@seller_bj_chaoyang.area_zipcode).to eq(@state_chaoyang.zipcode)
    end

    it "return related area province name" do
      expect(@seller_bj_chaoyang.area_province_name).to eq(@state_chaoyang.province_name)
    end

    it "return related area city name" do
      expect(@seller_bj_chaoyang.area_city_name).to eq(@state_chaoyang.city_name)
    end

    it "return related area state name" do
      expect(@seller_bj_chaoyang.area_state_name).to eq(@state_chaoyang.state_name)
    end
  end
end
