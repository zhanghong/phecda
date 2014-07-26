class CreateCoreStocks < ActiveRecord::Migration
  def change
    create_table :core_stocks do |t|
      t.integer         :account_id,    default: 0
      t.string          :name,          limit: 50,    default: ""
      t.datetime      :deleted_at
      t.timestamps
    end
  end
end
