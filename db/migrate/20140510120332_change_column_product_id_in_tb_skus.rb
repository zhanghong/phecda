class ChangeColumnProductIdInTbSkus < ActiveRecord::Migration
  def change
    change_column   :tb_skus,   :product_id,    :integer,   default: 0
  end
end
