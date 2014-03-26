class CreateTbCategories < ActiveRecord::Migration
  def change
    create_table :tb_categories do |t|
    	t.string 	:name,   			:default => "", :limit => 30
      t.integer :shop_id,  		:default => 0,  :limit => 4
      t.string  :status,       :default => "", :limit => 20
      t.integer :parent_id,   :default => 0,  :limit => 4
      t.integer :lft,         :default => 0,  :limit => 4
      t.integer :rgt,         :default => 0,  :limit => 4
      t.integer :depth,       :default => 0,  :limit => 4
      t.integer :use_days,    :default => 1,  :limit => 4
      t.timestamps
    end
    add_index		:tb_categories,		[:shop_id,	:name],	name: "idx_by_shop_id_and_name"		
  end
end
