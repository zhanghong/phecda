class CreateTbTrades < ActiveRecord::Migration
  def change
    create_table :tb_trades do |t|
      t.integer         :shop_id,   default: 0
      t.string          :tid,       default: "",  limit: 18
      t.integer         :num,       default: 0
      t.string          :num_iid,   default: "",  limit: 15
      t.string          :status,    default: "",  limit: 30
      t.string          :title,     default: "",  limit: 30
      t.string          :sold_type, default: "",  limit: 30
      t.decimal         :price,     default: "0.0", precision: 8, scale: 2
      t.decimal         :seller_cod_fee,  default: "0.0", precision: 8, scale: 2
      t.decimal         :discount_fee,    default: "0.0", precision: 8, scale: 2
      t.decimal         :point_fee,       default: "0.0", precision: 8, scale: 2
      t.decimal         :total_fee,       default: "0.0", precision: 8, scale: 2
      t.boolean         :has_post_fee,    default: false
      t.boolean         :is_lgtype,       default: false
      t.boolean         :is_brand_sale,   default: false
      t.boolean         :is_force_wlb,    default: false
      t.datetime        :created
      t.datetime        :pay_time
      t.datetime        :modified
      t.datetime        :end_time
      t.string          :buyer_message,   default: ""
      t.string          :alipay_id,       default: "",  limit: 20
      t.string          :alipay_no,       default: "",  default: 30
      t.string          :buyer_memo,      default: ""
      t.string          :seller_memo,     default: ""
      t.string          :invoice_name,    default: "",  limit: 50
      t.string          :invoice_type,    default: "",  limit: 10
      t.string          :buyer_nick,      default: "",  limit: 50
      t.string          :buyer_area,      default: "",  limit: 30
      t.string          :buyer_email,     default: "",  limit: 50
      t.decimal         :credit_card_fee, default: "0.0", precision: 8, scale: 2
      t.string          :shipping_type,   default: "",  limit: 15
      t.decimal         :adjust_fee,      default: "0.0", precision: 8, scale: 2
      t.integer         :buyer_obtain_point_fee,  default: 0
      t.decimal         :cod_fee,         default: "0.0", precision: 8, scale: 2
      t.string          :trade_from,      default: "",  limit: 10
      t.string          :cod_status,      default: "",  limit: 30
      t.decimal         :commission_fee,  default: "0.0", precision: 8, scale: 2
      t.string          :trade_memo,      default: ""
      t.boolean         :is_daixiao,      default: false
      t.string          :receiver_city,   default: "",  limit: "20"
      t.string          :receiver_district, default: "",  limit: 20
      t.string          :seller_nick,     default: "",  limit: 30
      t.decimal         :payment,         default: "0.0", precision: 8, scale: 2
      t.decimal         :post_fee,        default: "0.0", precision: 8, scale: 2
      t.string          :buyer_alipay_no, default: "",  limit: 50
      t.string          :receiver_name,   default: "",  limit: 20
      t.string          :receiver_state,  default: "",  limit: 20
      t.string          :receiver_address,  default: "",  limit: 70
      t.string          :receiver_zip,    default: "",    limit: 6
      t.string          :receiver_mobile, default: "",    limit: 11
      t.string          :receiver_phone,  default: "",    limit: 20
      t.datetime        :consign_time
      t.decimal         :received_payment,  default: "0.0", precision: 8, scale: 2
      t.timestamps
    end
  end
end
