class RenameTableUsersShops < ActiveRecord::Migration
  def change
    rename_table  :users_shops,   :users_accounts
    rename_column :users_accounts,   :shop_id,   :account_id
  end
end
