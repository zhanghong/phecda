class AddColumnCidsToTbCategories < ActiveRecord::Migration
  def change
  	add_column		:tb_categories,		:tb_type,		:string,		limit: 20
  	add_column		:tb_categories,		:cid,				:string,		limit: 15
  	add_column		:tb_categories,		:parent_cid,	:string,	limit: 15
  	add_column		:tb_categories,		:pic_url,			:string
  	add_column		:tb_categories,		:sort_order,	:integer
  end
end
