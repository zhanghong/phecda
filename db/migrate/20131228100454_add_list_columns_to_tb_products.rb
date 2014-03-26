class AddListColumnsToTbProducts < ActiveRecord::Migration
  def change
  	drop_table :tb_products

  	create_table :tb_products do |t|
    	t.integer	 	:shop_id
    	t.integer		:category_id,				default: 0
    	t.string		:detail_url,				default: ""
    	t.string		:num_iid,						default: "", 	limit: 20
    	t.string   	:title,							limit: 100,		default: ""
    	t.string		:sale_type,					default: "fixed",	limit: 20
    	t.text			:desc
    	t.string		:props_name 
    	t.datetime	:tb_created_at
    	t.boolean		:is_lightning_consignment
    	t.integer		:is_fenxiao
    	t.integer		:auction_point,			default: 0
    	t.string		:property_alias,		default: ""
    	t.string		:template_id,				default: "",	limit: 20
    	t.string		:features,					default: ""
    	t.integer		:valid_thru,				default: 7
    	t.string		:order_id,					default: "",	limit: 20
    	t.string		:auto_fill,					default: "",	limit: 20
    	t.string		:cid,								default: "",	limit: 20
    	t.string		:seller_cids,				default: ""
    	t.string		:props,							default: ""
    	t.string		:input_pids,				default: ""
    	t.string		:input_str,					default: ""
    	t.string		:pic_url,						default: ""
    	t.integer		:num,								default: 0
    	t.datetime	:list_at
    	t.datetime	:delist_at
    	t.string		:stuff_status,			default: ""
    	t.decimal   :price,			        precision: 8, scale: 2
    	t.decimal		:post_fee,					precision: 8, scale: 2
    	t.decimal		:express_fee,				precision: 8, scale: 2
    	t.decimal		:ems_fee,						precision: 8, scale: 2
    	t.boolean		:has_discount,			default: false
    	t.string		:freight_payer,			default: "",	limit: 20
    	t.boolean		:has_invoice
    	t.boolean		:has_warranty
    	t.boolean		:has_showcase
    	t.datetime	    :tb_modified_at
    	t.string		:increment,					default: ""			
    	t.string		:approve_status,		limit: 15,		default: "instock"
    	t.string		:postage_id,				default: "",	limit: 20
    	t.string		:product_id,				default: "",	limit: 20
    	t.boolean		:is_virtual
    	t.boolean		:is_taobao
    	t.boolean		:is_ex
    	t.boolean		:is_timing
    	t.boolean		:one_station
    	t.string		:second_kill,				default: "",	limit: 20
      t.timestamps
    end
    add_index		:tb_products,		[:shop_id,	:category_id],	name: "idx_by_shop_id_and_category_id"	
    add_index		:tb_products,		[:shop_id,	:title],				name: "idx_by_shop_id_and_title"
  end
end
