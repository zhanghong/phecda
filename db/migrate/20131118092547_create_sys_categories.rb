class CreateSysCategories < ActiveRecord::Migration
  def change
    create_table :sys_categories do |t|
      t.string :name,   :default => "", :limit => 30
      t.integer :account_id,  :default => 0,  :limit => 4
      t.string :status,       :default => "", :limit => 20
      t.integer :parent_id,   :default => 0,  :limit => 4
      t.integer :lft,         :default => 0,  :limit => 4
      t.integer :rgt,         :default => 0,  :limit => 4
      t.integer :depth,       :default => 0,  :limit => 4
      t.integer :use_days,    :default => 1,  :limit => 4
      t.timestamps
    end
  end
end
