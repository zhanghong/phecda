class CreateTbSkus < ActiveRecord::Migration
  def change
    create_table :tb_skus do |t|
    	t.integer				:shop_id,				default: 0
    	t.string				:product_id,		limit: 30
      t.timestamps
    end
    add_index		:tb_skus,	[:shop_id,	:product_id],	name: "idx_by_shop_id_and_product_id"
  end
end
