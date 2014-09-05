# encoding : utf-8 -*-
require 'spec_helper'

describe Core::Area do
  context "belongs to association" do
    [:updater].each do |name|
      it { should belong_to(name)}
    end
  end

  context "has many association with dependent" do
    [:seller_areas, :logistic_areas].each do |name|
      it { should have_many(name).dependent(:destroy)}
    end
  end

  context "check shown attributes" do
    it "check list page view attributs" do
      arr = %w(zipcode province_name city_name state_name)
      expect(Core::Area.list_shown_attributes).to eq(arr)
    end

    it "check show page view attributes" do
      arr = %w(zipcode province_name city_name state_name)
      expect(Core::Area.detail_shown_attributes).to eq(arr)
    end
  end

  context "filter find mine method" do
    let(:pro_bj) {create(:tb_pro_beijing, parent: nil)}
    let(:city_bj) {create(:tb_city_beijing, parent: pro_bj)}
    let(:state_chaoyang) {create(:tb_state_bj_chaoyang, parent: city_bj)}
    let(:state_haidian) {create(:tb_state_bj_haidian, parent: city_bj)}

    context "find by name" do
      it "matching by name key world 北京" do
        conds = {name: "北京"}
        expect(Core::Area.find_mine(conds)).to eq([pro_bj, city_bj])
      end

      it "non-matching by name key world 天津" do
        conds = {name: "天津"}
        expect(Core::Area.find_mine(conds)).to eq([])
      end
    end

    context "find by parent id" do
      it "matching by city bj id" do
        conds = {parent_id: city_bj.id}
        expect(Core::Area.find_mine(conds)).to eq([state_chaoyang, state_haidian])
      end

      it "non-matching by name key world 天津" do
        conds = {parent_id: state_chaoyang.id}
        expect(Core::Area.find_mine(conds)).to eq([])
      end
    end
  end

  # context "check reset all areas level" do
  #   it "set level" do
  #     pro_bj = create(:tb_pro_beijing, parent: nil)
  #     city_bj = create(:tb_city_beijing, parent: pro_bj)
  #     state_chaoyang = create(:tb_state_bj_chaoyang, parent: city_bj)
  #     Core::Area.reset_levels
  #     expect(pro_bj.level_id).to  eq(1)
  #     expect(city_bj.level_id).to eq(2)
  #     expect(state_chaoyang.level_id).to eq(3)
  #   end
  # end

  context "return self and children nodes" do
    it "return beijing provoce all nodes" do
      pro_bj = create(:tb_pro_beijing, parent: nil)
      city_bj = create(:tb_city_beijing, parent: pro_bj)
      state_chaoyang = create(:tb_state_bj_chaoyang, parent: city_bj)
      tb_state_bj_haidian = create(:tb_state_bj_haidian, parent: city_bj)
      expect(Core::Area.node_with_children(pro_bj)).to eq([pro_bj, city_bj, state_chaoyang, tb_state_bj_haidian])
    end

    it "do not return tb_state_bj_haidian state when parent is null" do
      pro_bj = create(:tb_pro_beijing, parent: nil)
      city_bj = create(:tb_city_beijing, parent: pro_bj)
      state_chaoyang = create(:tb_state_bj_chaoyang, parent: city_bj)
      tb_state_bj_haidian = create(:tb_state_bj_haidian, parent: nil)
      expect(Core::Area.node_with_children(pro_bj)).to eq([pro_bj, city_bj, state_chaoyang])
    end
  end

  context "return area name" do
    it "return taobao name if area only has taobao name" do
      pro_bj = create(:tb_pro_beijing, parent: nil)
      expect(pro_bj.name).to eq(pro_bj.taobao_name)
    end

    it "return taobao name if area has taobao name and jingdong name" do
      city_bj = create(:tb_city_beijing, jingdong_id: 1, jingdong_name: "北京", parent: nil)
      expect(city_bj.name).to eq(city_bj.taobao_name)
    end

    it "return jingdong name if area only has jingdong name" do
      city_bj = create(:jd_city_beijing, parent: nil)
      expect(city_bj.name).to eq(city_bj.jingdong_name)
    end

    it "return empty string if area taobao name and jingdong name all is empty" do
      area = create(:core_area, parent: nil)
      expect(area.name).to eq("")
    end
  end

  context "return area object province name" do
    let(:pro_bj) {create(:tb_pro_beijing, parent: nil)}
    let(:city_bj) {create(:tb_city_beijing, parent: pro_bj)}
    let(:state_chaoyang) {create(:tb_state_bj_chaoyang, parent: city_bj)}

    it "return name if area is a province object" do
      expect(pro_bj.province_name).to eq(pro_bj.name)
    end

    it "return blongs_to province name if area is a city object" do
      expect(city_bj.province_name).to eq(pro_bj.name)
    end

    it "return blongs_to province name if area is a state object" do
      expect(state_chaoyang.province_name).to eq(pro_bj.name)
    end

    it "return blank string if area level_id not in 1-3" do
      state_chaoyang.level_id = 4
      expect(state_chaoyang.province_name).to eq("")
    end

    it "return blank string if area level_id is nil" do
      state_chaoyang.level_id = nil
      expect(state_chaoyang.province_name).to eq("")
    end
  end

  context "return area object city name" do
    let(:pro_bj) {create(:tb_pro_beijing, parent: nil)}
    let(:city_bj) {create(:tb_city_beijing, parent: pro_bj)}
    let(:state_chaoyang) {create(:tb_state_bj_chaoyang, parent: city_bj)}

    it "return blank string if area is a province object" do
      expect(pro_bj.city_name).to eq("")
    end

    it "return self name if area is a city object" do
      expect(city_bj.city_name).to eq(city_bj.name)
    end

    it "return blongs_to city name if area is a state object" do
      expect(state_chaoyang.city_name).to eq(city_bj.name)
    end

    it "return blank string if area level_id not in 1-3" do
      state_chaoyang.level_id = 4
      expect(state_chaoyang.province_name).to eq("")
    end

    it "return blank string if area level_id is nil" do
      state_chaoyang.level_id = nil
      expect(state_chaoyang.province_name).to eq("")
    end
  end

  context "return area object state name" do
    let(:pro_bj) {create(:tb_pro_beijing, parent: nil)}
    let(:city_bj) {create(:tb_city_beijing, parent: pro_bj)}
    let(:state_chaoyang) {create(:tb_state_bj_chaoyang, parent: city_bj)}

    it "return blank string if area is a province object" do
      expect(pro_bj.state_name).to eq("")
    end

    it "return blank string if area is a city object" do
      expect(city_bj.state_name).to eq("")
    end

    it "return blongs_to city name if area is a state object" do
      expect(state_chaoyang.state_name).to eq(state_chaoyang.name)
    end

    it "return blank string if area level_id not in 1-3" do
      state_chaoyang.level_id = 4
      expect(state_chaoyang.state_name).to eq("")
    end

    it "return blank string if area level_id is nil" do
      state_chaoyang.level_id = nil
      expect(state_chaoyang.state_name).to eq("")
    end
  end

  context "return area object full name" do
    let(:pro_bj) {create(:tb_pro_beijing, parent: nil)}
    let(:city_bj) {create(:tb_city_beijing, parent: pro_bj)}
    let(:state_chaoyang) {create(:tb_state_bj_chaoyang, parent: city_bj)}

    it "equal self name if area is a province object" do
      expect(pro_bj.full_name).to eq(pro_bj.name)
    end

    it "return province and self name if area is a city object" do
      name = "#{pro_bj.name}-#{city_bj.name}"
      expect(city_bj.full_name).to eq(name)
    end

    it "return blongs_to province,city and self name if area is a state object" do
      name = "#{pro_bj.name}-#{city_bj.name}-#{state_chaoyang.name}"
      expect(state_chaoyang.full_name).to eq(name)
    end

    it "return blank string if area level_id not in 1-3" do
      state_chaoyang.level_id = 4
      expect(state_chaoyang.full_name).to eq("")
    end

    it "return blank string if area level_id is nil" do
      state_chaoyang.level_id = nil
      expect(state_chaoyang.full_name).to eq("")
    end
  end

  context "return area is a leaf node" do
    let(:pro_bj) {create(:tb_pro_beijing, parent: nil)}
    let(:city_bj) {create(:tb_city_beijing, parent: pro_bj)}
    let(:state_chaoyang) {create(:tb_state_bj_chaoyang, parent: city_bj)}

    it "return false if area is a province object" do
      pro_bj
      city_bj
      expect(pro_bj.is_leaf).to eq(false)
    end

    it "return false if area is a city object" do
      pro_bj
      city_bj
      state_chaoyang
      expect(city_bj.is_leaf).to eq(false)
    end

    it "return true if area is a state object" do
      pro_bj
      city_bj
      state_chaoyang
      expect(state_chaoyang.is_leaf).to eq(true)
    end
  end
end
