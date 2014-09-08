class ChangeColumnCoreLogisticNameLength < ActiveRecord::Migration
  def change
    change_column :core_logistics, :name,  :string,  limit: 30, default: ""
  end
end
