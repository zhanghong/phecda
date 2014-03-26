class AddColumnExpiresAtToTbAppTokens < ActiveRecord::Migration
  def change
    add_column    :tb_app_tokens,   :expires_at,    :datetime
    add_column    :tb_app_tokens,   :expires,       :boolean
  end
end
