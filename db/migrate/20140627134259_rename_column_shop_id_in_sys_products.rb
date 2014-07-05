class RenameColumnShopIdInSysProducts < ActiveRecord::Migration
  def change
    rename_column   :sys_products,  :shop_id,   :account_id
  end
end
