class ChangeColumnsLongInTbShops < ActiveRecord::Migration
  def change
  	change_column		:tb_shops,	:cid,		:string,		limit: 50
  	change_column		:tb_shops,	:nick,	:string,		limit: 100
  	change_column		:tb_shops,	:title,	:string,		limit: 100
  end
end
