class RecreateTableCoreAreas < ActiveRecord::Migration
  def change
    drop_table  :core_areas
    create_table "core_areas", force: true do |t|
      t.integer  "taobao_id",                 default: 0
      t.string   "taobao_name",    limit: 20, default: ""
      t.integer  "jingdong_id",               default: 0
      t.string   "jingdong_name",  limit: 20, default: ""
      t.integer  "level_id"
      t.integer  "parent_id"
      t.boolean  "active",                    default: true
      t.string   "pinyin",         limit: 50, default: ""
      t.integer  "children_count",            default: 0
      t.integer  "lft",                       default: 0
      t.integer  "rgt",                       default: 0
      t.integer  "area_type"
      t.string   "zipcode",        limit: 6,  default: ""
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "updater_id",                default: 0
    end
  end
end
