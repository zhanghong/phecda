class CreateTbApps < ActiveRecord::Migration
  def change
    create_table :tb_apps do |t|
      t.string          :name
      t.string          :key_id,    default: "",    limit: 15
      t.string          :secret,    default: "",    limit: 40
      t.timestamps
    end
  end
end
