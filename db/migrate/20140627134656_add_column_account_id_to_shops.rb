class AddColumnAccountIdToShops < ActiveRecord::Migration
  def change
    add_column  :shops,   :account_id,    :integer,   default: 0
  end
end
