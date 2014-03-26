class CreateTbPropertyValues < ActiveRecord::Migration
  def change
    create_table :tb_property_values do |t|
    	t.integer				:shop_id,				default: 0
    	t.integer				:property_id,		default: 0
    	t.string				:name,					default: "",	limit: 20
      t.timestamps
    end
    add_index		:tb_property_values,		[:shop_id,	:property_id],	name: "idx_by_shop_id_and_property_id"		
  end
end
