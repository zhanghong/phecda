class CreateTableTask < ActiveRecord::Migration
  def change
    create_table :edm_task do |t|
      t.string    :type,            default: "",  limit: 30
      t.string    :category_id,     default: 0
      t.string    :title,           default: "",  limit: 50
      t.string    :status,          default: "pinding", limit: 30
      t.text      :content
      t.integer   :creater_id,      default: 0
      t.integer   :updater_id,      default: 0
      t.datetime  :created_at
      t.datetime  :updated_at
    end
    add_index :edm_task,  [:type, :category_id],  name: "idx_by_type_and_category_id"
  end
end
