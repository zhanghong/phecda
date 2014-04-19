class AddColumnAppIdToTbAppTokens < ActiveRecord::Migration
  def change
    remove_column  :tb_shops,   :app_id
    add_column     :tb_app_tokens,  :app_id,  :integer
  end
end
