class CreateSysSkus < ActiveRecord::Migration
  def change
    create_table :sys_skus do |t|
    	t.integer				:account_id,		default: 0
    	t.string				:product_id,		limit: 30
      t.timestamps
    end

    add_index		:sys_skus,	[:account_id,	:product_id],	name: "idx_by_account_id_and_product_id"
  end
end
