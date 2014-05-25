class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string   "type",           limit: 30
      t.string   "cid",            limit: 50,  default: ""
      t.string   "nick",           limit: 100, default: ""
      t.string   "title",          limit: 100, default: ""
      t.string   "desc",                       default: ""
      t.string   "bulletin",                   default: ""
      t.string   "pic_path",                   default: ""
      t.datetime "tb_created_at"
      t.datetime "tb_modified_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "user_id",        limit: 20,  default: ""
      t.string   "sid",            limit: 20,  default: ""
      t.timestamps
    end
  end
end
