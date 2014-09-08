class AddUpdaterAndDeleterToSysTables < ActiveRecord::Migration
  def change
    rename_column   :sys_categories,  :status,    :state
    change_column   :sys_categories,  :state,     :string,  default: "actived"

    rename_column   :sys_properties,  :status,    :state
    change_column   :sys_properties,  :state,     :string,  default: "actived"
  end
end
