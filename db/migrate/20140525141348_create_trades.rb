class CreateTrades < ActiveRecord::Migration
  def change
    rename_table   :tb_trades,      :trades
    add_column     :trades,         :type,      :string,    default: "",          limit: 30
    Trade.update_all(type: "Tb::Trade")
  end
end
