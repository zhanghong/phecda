class CreateTbProperties < ActiveRecord::Migration
  def change
    create_table :tb_properties do |t|
    	t.integer			:shop_id,			default: 0
    	t.string			:name,				limit: 30,	default: ""
    	t.string			:status,			limit: 20,	default: ""
      t.timestamps
    end
    add_index		:tb_properties,	[:shop_id,	:name],		name: "idx_by_shop_id_and_name"
    add_index		:tb_properties,	[:shop_id,	:status],	name: "idx_by_shop_id_and_status"		
  end
end
