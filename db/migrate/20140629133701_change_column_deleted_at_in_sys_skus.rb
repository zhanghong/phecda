class ChangeColumnDeletedAtInSysSkus < ActiveRecord::Migration
  def change
    Sys::Sku.update_all(deleted_at: nil)
    change_column   :sys_skus,    :deleted_at,    :datetime
  end
end
