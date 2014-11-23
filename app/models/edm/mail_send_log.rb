# encoding : utf-8 -*-
# create_table "edm_mail_send_log", force: true do |t|
#   t.integer  "task_id",               default: 0
#   t.integer  "email_id",              default: 0
#   t.string   "email",      limit: 80, default: ""
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.integer  "sent_count",            default: 0
#   t.string   "domain",     limit: 30, default: ""
# end
# add_index "edm_mail_send_log", ["task_id"], name: "idx_by_task_id", using: :btree
class Edm::MailSendLog < ActiveRecord::Base
  self.table_name = :edm_mail_send_log

  def self.rand_find(task_id, skip_sent = true)
    conditions = [["task_id = ?"], task_id]
    if skip_sent
      conditions[0] << "sent_count = ?"
      conditions << 0
    end
    conditions[0] = conditions[0].join(" AND ")

    where(conditions).group("domain").order("RAND()")
  end
end
