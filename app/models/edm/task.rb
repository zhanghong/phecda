# encoding : utf-8 -*-
# create_table "edm_task", force: true do |t|
#   t.string   "type",        limit: 30, default: ""
#   t.string   "category_id",            default: "0"
#   t.string   "title",       limit: 50, default: ""
#   t.string   "status",      limit: 30, default: "pinding"
#   t.text     "content"
#   t.integer  "creater_id",             default: 0
#   t.integer  "updater_id",             default: 0
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "edm_task", ["type", "category_id"], name: "idx_by_type_and_category_id", using: :btree
class Edm::Task < ActiveRecord::Base
  self.table_name = :edm_task

  def transfer_content(log_id = 0)
    self.content.gsub(/http:\/\/www\.ihaveu\.com[^(\"|\')]*/){|l| (l =~ /l\/(\d+)$/)? %(http://data.ihaveu.com/api/cmc/#{log_id}?&l=#{$1}) : %(http://data.ihaveu.com/api/callbacks/#{log_id}/common_mall_click?mt=#{mail_type}&cb=#{CGI.escape(l)}) }.
        sub(%(</body>), %(<img src='http://data.ihaveu.com/api/cmo/#{log_id}?' width='1' height='1'/></body>))
  end
end
