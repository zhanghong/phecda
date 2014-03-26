class CreateTbSkuProperties < ActiveRecord::Migration
  def change
    create_table :tb_sku_properties do |t|
    	t.integer			:sku_id,							default: 0
    	t.integer			:property_value_id,		default: 0
      t.timestamps
    end
    add_index			:tb_sku_properties,		[:sku_id,	:property_value_id],		name: "idx_by_sku_id_and_property_id"	
  end
end
