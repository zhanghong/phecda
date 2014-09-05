# encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :core_area, :class => 'Core::Area' do
    taobao_id 0
    taobao_name ""
    jingdong_id 0
    jingdong_name ""
    association :parent
    active true
    zipcode nil
    pinyin ""

    factory :parent do

    end

    factory :tb_pro_beijing do
      taobao_id 110000
      taobao_name "北京"
      level_id 1
      pinyin "bj"
    end

    factory :tb_city_beijing do
      taobao_id 110100
      taobao_name "北京市"
      level_id 2
      pinyin "bjs"
    end

    factory :tb_state_bj_chaoyang do
      taobao_id 110105
      taobao_name "朝阳区"
      level_id 3
      pinyin "cyq"
    end

    factory :tb_state_bj_haidian do
      taobao_id 110108
      taobao_name "海淀区"
      level_id 3
      pinyin "hdq"
    end

    factory :jd_city_beijing do
      jingdong_id 1
      jingdong_name "北京"
      level_id 2
      pinyin "bjs"
    end

    factory :jd_state_bj_chaoyang do
      jingdong_id 72
      jingdong_name "朝阳区"
      level_id 3
      pinyin "cyq"
    end

    factory :jd_state_bj_haidian do
      jingdong_id 2800
      jingdong_name "海淀区"
      level_id 3
      pinyin "hdq"
    end
  end
end
