class RenameColumnZipInCoreAreas < ActiveRecord::Migration
  def change
    rename_column   :core_areas,  :zip,   :zipcode
  end
end
