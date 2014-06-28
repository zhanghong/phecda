# encoding : utf-8 -*-
# create_table "settings", force: true do |t|
#   t.string   "var",                   null: false
#   t.text     "value"
#   t.integer  "thing_id"
#   t.string   "thing_type", limit: 30
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree
class Settings < RailsSettings::CachedSettings
end
