class CreateCoreSellerAreas < ActiveRecord::Migration
  def change
    create_table :core_seller_areas do |t|
      t.integer       :account_id
      t.integer       :seller_id
      t.integer       :area_id
      t.integer       :user_id
      t.timestamps
    end
  end
end
