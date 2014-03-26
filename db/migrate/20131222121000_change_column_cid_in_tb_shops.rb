class ChangeColumnCidInTbShops < ActiveRecord::Migration
  def change
  	change_column		:tb_shops,	:cid,		:string,		limit: 20,	default: ""
  	remove_column		:tb_shops,	:sid
  end
end
