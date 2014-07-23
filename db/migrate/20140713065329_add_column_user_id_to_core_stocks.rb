class AddColumnUserIdToCoreStocks < ActiveRecord::Migration
  def change
    add_column  :core_stocks,   :user_id,   :integer,   default: 0
  end
end
