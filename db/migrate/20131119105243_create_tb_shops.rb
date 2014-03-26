class CreateTbShops < ActiveRecord::Migration
  def change
    create_table :tb_shops do |t|
      t.integer       :account_id,  :default => 0,  :limit => 5
      t.integer       :sid,  :default => 0
      t.integer       :cid,  :default => 0
      t.string        :nick,    :default => "", :limit => 30
      t.string        :title,   :default => "", :limit => 50
      t.string        :auth_type, :default => "", :limit => 10
      t.string        :desc,    :default => ""
      t.string        :bulletin,  :default => ""
      t.string        :pic_path,  :default => ""
      t.datetime      :tb_created_at
      t.datetime      :tb_modified_at
      t.timestamps
    end
  end
end
