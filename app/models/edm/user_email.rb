# encoding : utf-8 -*-
# create_table "edm_user_email", force: true do |t|
#   t.string   "email",      limit: 80, default: ""
#   t.string   "domain",     limit: 50, default: ""
#   t.string   "status",     limit: 20, default: "actived"
#   t.integer  "creater_id",            default: 0
#   t.integer  "updater_id",            default: 0
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "name",       limit: 50, default: ""
# end
# add_index "edm_user_email", ["domain", "status"], name: "idx_by_domail_and_status", using: :btree
class Edm::UserEmail < ActiveRecord::Base
  self.table_name = :edm_user_email

  before_save   :set_domain

private
  def set_domain
    self.domain = self.email.to_s.split("@").last
  end
end
