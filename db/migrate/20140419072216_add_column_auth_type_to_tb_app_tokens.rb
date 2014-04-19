class AddColumnAuthTypeToTbAppTokens < ActiveRecord::Migration
  def change
    add_column  :tb_app_tokens,   :auth_type,   :string,     limit: 10,  default: ""
    remove_column :tb_shops,      :auth_type
  end
end
