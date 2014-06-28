class AddColumnAccountIdToProducts < ActiveRecord::Migration
  def change
    #add_column    :products,    :account_id,    :integer,   default: 0

    Account.all.each do |account|
      Account.current = account
      account.shops.each do |shop|
        Product.update_all({account_id: account.id}, shop_id: shop.id)
      end
    end
  end
end
