class CreateCoreSellers < ActiveRecord::Migration
  def change
    create_table :core_sellers do |t|
      t.integer     :account_id
      t.integer     :parent_id
      t.integer     :user_id
      t.string      :name,          limit: 20,    default: ""
      t.string      :fullname,      limit: 50,    default: ""
      t.string      :mobile,        limit: 50,    default: ""
      t.string      :phone,         limit: 50,    default: ""
      t.string      :email
      t.string      :address,       limit: 50,    default: ""
      t.integer     :lft,           default: 0
      t.integer     :rgt,           default: 0
      t.integer     :children_count,  default: 0
      t.string      :pinyin
      t.integer     :stock_id,      default: 0
      t.datetime    :deleted_at
      t.timestamps
    end
  end
end
