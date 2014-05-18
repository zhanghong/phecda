class ChangeColumnNickInTbAppTokens < ActiveRecord::Migration
  def change
    change_column   :tb_app_tokens,   :nick,    :string,  limit: 100, default: ""
  end
end