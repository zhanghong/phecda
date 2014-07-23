class AddColumnLevelIdToCoreAreas < ActiveRecord::Migration
  def change
    add_column  :core_areas,    :level_id,    :integer
    Core::Area.reset_levels
  end
end
