class CreateTbOrders < ActiveRecord::Migration
  def change
    create_table :tb_orders do |t|
      t.integer       :trade_id,          default: 0
      t.integer       :num,               default: 0
      t.string        :oid,               default: "",  limit: 18
      t.string        :status,            default: "",  limit: 30
      t.string        :title,             default: "",  limit: 70

      t.string        :num_iid,           default: "",  limit: 15
      t.string        :item_meal_id,      default: "",  limit: 15
      t.string        :sku_id,            default: "",  limit: 15
      t.string        :outer_sku_id,      default: "",  limit: 15
      t.string        :order_from,        default: "",  limit: 10

      t.decimal       :price,             default: "0.0", precision: 8, scale: 2
      t.decimal       :total_fee,         default: "0.0", precision: 8, scale: 2
      t.decimal       :payment,           default: "0.0", precision: 8, scale: 2
      t.decimal       :discount_fee,      default: "0.0", precision: 8, scale: 2
      t.decimal       :adjust_fee,        default: "0.0", precision: 8, scale: 2
      t.decimal       :divide_order_fee,  default: "0.0", precision: 8, scale: 2
      t.decimal       :part_mjz_discount, default: "0.0", precision: 8, scale: 2

      t.datetime      :modified
      t.datetime      :end_time
      t.datetime      :consign_time

      t.string        :sku_properties_name,   default: "",  limit: 50
      t.string        :refund_id,         default: "",  limit: 15

      t.string        :shipping_type,     default: "",  limit: 15
      t.string        :logistics_company, default: "",  limit: 10
      t.string        :invoice_no,        default: "",  limit: 15
      t.string        :store_code,        default: "",  limit: 20
      t.string        :item_meal_name,    default: "",  limit: 20
      t.string        :refund_status,     default: "",  limit: 30
      t.string        :outer_iid,         default: "",  limit: 20
      t.string        :seller_type,       default: "",  limit: 1
      t.string        :cid,               default: "",  limit: 20
      t.boolean       :is_oversold,       default: false
      t.boolean       :is_daixiao,        default: false
      t.timestamps
    end

    add_index  :tb_orders,    :trade_id,    name: "idx_by_trade_id"
  end
end
