class AddJingdongColumnsToCoreAreas < ActiveRecord::Migration
  def change
    add_column    :core_areas,  :taobao_id,   :integer,     default: 0
    rename_column :core_areas,  :name,        :taobao_name
    add_column    :core_areas,  :jingdong_id, :integer,     default: 0
    add_column    :core_areas,  :jingdong_name, :string,    default: "",  limit: 20      
  end
end
