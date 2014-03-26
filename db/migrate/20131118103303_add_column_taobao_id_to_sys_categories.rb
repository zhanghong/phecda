class AddColumnTaobaoIdToSysCategories < ActiveRecord::Migration
  def change
    add_column  :sys_categories,  :pic_url,   :string,  :default => ""
    add_column  :sys_categories,  :sort_order,  :integer
    add_column  :sys_categories,  :taobao_id, :integer, :default => 0
    add_column  :sys_categories,  :taobao_updated_at, :datetime
  end
end
