class CreateTbProducts < ActiveRecord::Migration
  def change
    create_table :tb_products do |t|
    	t.integer	 	:shop_id
    	t.integer		:category_id,				default: 0
    	t.string   	:title,							limit: 100,		default: ""
    	t.integer		:num,								default: 0
    	t.text			:description
    	t.string		:approve_status,		limit: 15,		default: "instock"
    	t.boolean		:has_discount,			default: false
    	t.string		:image
    	t.string		:outer_id
    	t.string		:product_id,				limit: 20,		default: ""
      t.timestamps
    end
    add_index		:tb_products,		[:shop_id,	:category_id],	name: "idx_by_shop_id_and_category_id"	
    add_index		:tb_products,		[:shop_id,	:title],				name: "idx_by_shop_id_and_title"	
  end
end
