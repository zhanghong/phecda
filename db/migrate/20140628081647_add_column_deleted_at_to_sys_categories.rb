class AddColumnDeletedAtToSysCategories < ActiveRecord::Migration
  def change
    add_column  :sys_categories,    :deleted_at,    :datetime
  end
end
