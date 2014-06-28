class AddColumnNumAndPriceToSysSkus < ActiveRecord::Migration
  def change
    add_column    :sys_skus,    :number,    :integer,   default: 0
    add_column    :sys_skus,    :price,     :decimal,   precision: 8, scale: 2,   default: 0.0
  end
end