class RenameTbSkus < ActiveRecord::Migration
  def change
    rename_table  :tb_skus,   :skus
    rename_column :skus,      :shop_id, :account_id
    add_column    :skus,      :type,    :string,    default: 20
    add_column    :skus,      :deleted_at,  :datetime
  end
end
