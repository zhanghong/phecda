class CreateSysSkuPropertyValues < ActiveRecord::Migration
  def change
    create_table :sys_sku_property_values do |t|
    	t.integer			:sku_id,							default: 0
    	t.integer			:property_value_id,		default: 0
      t.timestamps
    end

    add_index			:sys_sku_property_values,		[:sku_id,	:property_value_id],		name: "idx_by_sku_id_and_property_id"			
  end
end
