class CreateCorePermissions < ActiveRecord::Migration
  def change
    create_table :core_permissions do |t|
      t.string          :module_name,   limit: 20,  default: ""
      t.string          :group_name,    limit: 20,  default: ""
      t.string          :name,          limit: 20,  default: ""
      t.string          :subject_class, limit: 30,  default: ""
      t.string          :action,        limit: 50,  default: ""
      t.string          :ability_method,  limit: 50,  default: ""
      t.integer         :sort_num,        default: 9999
      t.integer         :updater_id,      default: 0
      t.integer         :deleter_id,      default: 0
      t.integer         :deleted_at
      t.timestamps
    end
    add_index :core_permissions,  [:sort_num],  name: "idx_by_sort_num"
  end
end
