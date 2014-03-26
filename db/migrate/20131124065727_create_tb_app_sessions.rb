class CreateTbAppSessions < ActiveRecord::Migration
  def change
    create_table :tb_app_sessions do |t|
    	t.integer     :shop_id,   :limit => 4
      t.string      :nick, :limit => 30
      t.string			:app_key,	:limit => 20
      t.string			:app_secret,	:limit => 80
      t.string      :session_key,	:limit => 80
      t.integer     :expires_at
      t.string      :refresh_token,	:limit => 80
      t.date     		:refresh_token_expires_at
      t.string      :r1_expires_in
      t.boolean     :r1_can_refresh,	:default => false
      t.string      :r2_expires_in
      t.boolean     :r2_can_refresh,	:default => false
      t.string      :w1_expires_in
      t.boolean     :w1_can_refresh,	:default => false
      t.string      :w2_expires_in
      t.boolean     :w2_can_refresh,	:default => false
      t.boolean			:is_sandbox,			:default => false
      t.boolean			:use_curl,				:default => false
      t.timestamps
    end
  end
end
