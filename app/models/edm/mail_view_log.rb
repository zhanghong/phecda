# encoding : utf-8 -*-
# create_table "edm_mail_view_log", force: true do |t|
#   t.integer  "send_log_id"
#   t.integer  "task_id"
#   t.string   "view_type",   limit: 30, default: "open"
#   t.string   "user_agent"
#   t.string   "user_ip",     limit: 15
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "edm_mail_view_log", ["task_id", "view_type"], name: "idx_by_task_id_and_view_type", using: :btree
class Edm::MailViewLog < ActiveRecord::Base
  self.table_name = :edm_mail_view_log
end
