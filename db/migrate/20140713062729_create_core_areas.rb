class CreateCoreAreas < ActiveRecord::Migration
  def change
    create_table(:core_areas, id: false) do |t|
      t.integer       :id
      t.string        :name,      default: "",    limit: 20
      t.integer       :parent_id
      t.boolean       :active,    default: true
      t.string        :pinyin,    default: "",    limit: 50
      t.integer       :children_count,  default: 0
      t.integer       :lft,       default: 0
      t.integer       :rgt,       default: 0
      t.integer       :area_type
      t.string        :zip,       default: "",    limit: 6
      t.timestamps
    end
  end
end
