class AddColumnUserIdToTbShops < ActiveRecord::Migration
  def change
  	add_column	:tb_shops,	:user_id,		:string,	limit: 20,	default: ""
  	add_column	:tb_shops,	:sid,		:string,	limit: 20,	default: ""
  end
end
