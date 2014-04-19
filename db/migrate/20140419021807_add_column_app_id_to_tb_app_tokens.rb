class AddColumnAppIdToTbAppTokens < ActiveRecord::Migration
  def change
    add_column     :tb_app_tokens,  :app_id,  :integer
  end
end
