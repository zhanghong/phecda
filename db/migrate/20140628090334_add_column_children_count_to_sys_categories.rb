class AddColumnChildrenCountToSysCategories < ActiveRecord::Migration
  def change
    add_column    :sys_categories,  :children_count,  :integer,   default: 0
  end
end
