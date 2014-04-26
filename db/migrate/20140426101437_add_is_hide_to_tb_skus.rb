class AddIsHideToTbSkus < ActiveRecord::Migration
  def change
    add_column  :tb_skus,   :is_hide,   :boolean,   default: false
  end
end
