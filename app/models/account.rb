# encoding : utf-8 -*-
# create_table "accounts", force: true do |t|
#   t.string   "name",       limit: 30, default: ""
#   t.string   "phone",      limit: 13, default: ""
#   t.string   "email",      limit: 50, default: ""
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
class Account < ActiveRecord::Base
end
