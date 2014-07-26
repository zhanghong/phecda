# encoding : utf-8 -*-
# create_table "core_permissions", force: true do |t|
#   t.string   "module_name",    limit: 20, default: ""
#   t.string   "group_name",     limit: 20, default: ""
#   t.string   "name",           limit: 20, default: ""
#   t.string   "subject_class",  limit: 30, default: ""
#   t.string   "action",         limit: 50, default: ""
#   t.string   "ability_method", limit: 50, default: ""
#   t.integer  "sort_num",                  default: 9999
#   t.integer  "updater_id",                default: 0
#   t.integer  "deleter_id",                default: 0
#   t.integer  "deleted_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "core_permissions", ["sort_num"], name: "idx_by_sort_num", using: :btree
class Core::Permission < ActiveRecord::Base
  belongs_to  :updater,   class_name: "User"
  belongs_to  :deleter,   class_name: "User"
  has_many    :account_permissions,   class_name: "Core::AccountPermission",  dependent: :destroy

  def self.list_shown_attributes
    %w(name module_name group_name)
  end

  def self.detail_shown_attributes
    %w(name module_name group_name subject_class action ability_mothod sort_num updater_name created_at updated_at)
  end

  def self.find_mine(params)
    find_scope = self

    conditions = [[]]

    [:name, :module_name, :group_name].each do |attr|
      if params[attr].blank?
        next
      else
        conditions[0] << "#{attr} LIKE ?"
        conditions << "%#{params[attr]}%"
      end
    end

    [:subject_class, :action, :updater_id].each do |attr|
      if params[attr].blank?
        next
      else
        conditions[0] << "#{attr} = ?"
        conditions << "%#{params[attr]}%"
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end

  def updater_name
    updater.try(:name)
  end

  def deleter_name
    deleter.try(:name)
  end

  def destroy
    update_attributes(deleted_at: Time.now, deleter_id: User.current_id)
  end
end
