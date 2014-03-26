class AddQueryAndTsIdToTbSkus < ActiveRecord::Migration
  def change
    add_column  :tb_skus,   :quantity,    :integer,   default: 0
    add_column  :tb_skus,   :ts_id,       :string,    default: "",  limit: 30
  end
end
