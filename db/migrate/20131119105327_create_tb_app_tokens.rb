class CreateTbAppTokens < ActiveRecord::Migration
  def change
    create_table :tb_app_tokens do |t|
      t.integer     :shop_id,   :limit => 4
      t.string      :user_id,   :limit => 20, :default => ""
      t.string      :nick, :limit => 30
      t.string      :access_token
      t.string      :token_type, :limit => 30
      t.integer     :expires_in
      t.string      :refresh_token
      t.integer     :re_expires_in
      t.integer     :r1_expires_in
      t.integer     :r2_expires_in
      t.integer     :w1_expires_in
      t.integer     :w2_expires_in
      t.integer     :sub_user_id
      t.string      :sub_nick,    :limit => 30
      t.timestamps
    end

    add_index :tb_app_tokens, :shop_id, name: "idx_by_shop_id"
  end
end
