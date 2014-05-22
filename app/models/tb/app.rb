# encoding : utf-8 -*-
# create_table "tb_apps", force: true do |t|
#   t.string   "name"
#   t.string   "key_id",     limit: 15, default: ""
#   t.string   "secret",     limit: 40, default: ""
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
class Tb::App < ActiveRecord::Base
end
