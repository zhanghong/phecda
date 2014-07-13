class AddColumnShopIdToSkus < ActiveRecord::Migration
  def change
    add_column  :products,    :account_id,    :integer,   default: 0
    Tb::Shop.all.each do |shop|
      Tb::Product.update_all({account_id: shop.account_id}, {shop_id: shop.id})
    end

    add_column  :skus,    :shop_id,   :integer,   default: 0
    Sku.group("product_id").each do |sku|
      product = Product.find(sku.product_id)
      Sku.update_all({shop_id: product.shop_id}, {product_id: product.id})
    end
  end
end
