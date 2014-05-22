class AddColumnRefreshedAtToTbAppToken < ActiveRecord::Migration
  def change
    add_column    :tb_app_tokens,   :refreshed_at,    :datetime
  end
end
