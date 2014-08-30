# encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :admin_permission, :class => 'Admin::Permission' do
    module_name "系统设置"
    group_name  "权限管理"
    name "查看权限设置"
    subject_class "Admin::Permission"
    action_name   "read"
    ability_method ""
    sort_num  1
    tag_name  "查看权限设置"
    level "base"
    full_name "权限名"
    association :updater

    factory :trade_read_permission do
      module_name "订单管理"
      group_name  "可查看权限"
      name "查看订单"
      subject_class "Trade"
      action_name   "read"
      tag_name  "查看订单"
      full_name "查看订单"
      sort_num  1
    end

    factory :trade_update_permission do
      module_name "订单管理"
      group_name  "可操作权限"
      name "编辑订单"
      subject_class "Trade"
      action_name   "update"
      tag_name  "编辑订单"
      full_name "编辑订单"
      sort_num  2
    end

    factory :seller_read_permission do
      module_name "经销商管理"
      group_name  "可查看权限"
      name "查看经销商"
      subject_class "Core::Seller"
      action_name   "read"
      tag_name  "查看经销商"
      full_name "查看经销商"
      sort_num  3
    end

    factory :deleted_permission do
      association :deleter
      deleted_at Time.now
    end
  end
end
