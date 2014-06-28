class AddColumnNameAndDeletedAtToSysSkus < ActiveRecord::Migration
  def change
    add_column  :sys_skus,    :name,    :string,    default: "",  limit: 50
    add_column  :sys_skus,    :deleted_at,    :boolean,   default: false
  end
end
