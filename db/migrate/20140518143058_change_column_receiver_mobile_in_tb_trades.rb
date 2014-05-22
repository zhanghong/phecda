class ChangeColumnReceiverMobileInTbTrades < ActiveRecord::Migration
  def change
    change_column   :tb_trades,   :receiver_name,     :string,    limit: 50,    default: ""
    change_column   :tb_trades,   :receiver_zip,      :string,    limit: 10,    default: ""
    change_column   :tb_trades,   :receiver_mobile,   :string,    limit: 30,    default: ""
    change_column   :tb_trades,   :receiver_phone,    :string,    limit: 30,    default: ""
  end
end

