class AddColumnDeletedAtToSysProducts < ActiveRecord::Migration
  def change
    add_column    :sys_products,    :deleted_at,    :datetime
  end
end
