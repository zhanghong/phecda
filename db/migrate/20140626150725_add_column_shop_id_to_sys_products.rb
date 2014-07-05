class AddColumnShopIdToSysProducts < ActiveRecord::Migration
  def change
    remove_column   :sys_products,    :account_id
    remove_column   :sys_products,    :has_discount
    remove_column   :sys_products,    :approve_status
    remove_column   :sys_products,    :image
    remove_column   :sys_products,    :outer_id
    remove_column   :sys_products,    :product_id

    add_column      :sys_products,    :shop_id,   :integer,   default: 0
    add_column      :sys_products,    :state,     :string,    default: "activted",    limit: 20
    add_column      :sys_products,    :price,     :decimal,   precision: 8, scale: 2, default: 0
    add_column      :sys_products,    :created_at,     :datetime
    add_column      :sys_products,    :updated_at,     :datetime
  end
end
