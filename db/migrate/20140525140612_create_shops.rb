class CreateShops < ActiveRecord::Migration
  def change
    rename_table  :tb_shops,    :shops
    remove_column :shops,       :account_id
    remove_column :shops,       :user_id
    add_column    :shops,       :type,          :string,    default: "",    limit: 30
    Shop.update_all(type: "Tb::Shop")
  end
end
