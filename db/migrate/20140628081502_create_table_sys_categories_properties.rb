class CreateTableSysCategoriesProperties < ActiveRecord::Migration
  def change
    create_table :sys_categories_properties do |t|
      t.integer   :category_id
      t.integer   :property_id
    end
  end
end
