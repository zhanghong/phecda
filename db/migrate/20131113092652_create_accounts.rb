class CreateAccounts < ActiveRecord::Migration
  def change
    create_table "accounts", :force => true do |t|
      t.string   "name",              :default => "", :limit => 30
      t.string   "phone",             :default => "", :limit => 13
      t.string   "email",             :default => "", :limit => 50
      t.timestamps
    end
  end
end
