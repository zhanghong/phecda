class CreateSysPropertyValues < ActiveRecord::Migration
  def change
    create_table :sys_property_values do |t|
    	t.integer				:account_id,		default: 0
    	t.integer				:property_id,		default: 0
    	t.string				:name,					default: "",	limit: 20
      t.timestamps
    end
    add_index		:sys_property_values,		[:account_id,	:property_id],	name: "idx_by_account_id_and_property_id"		
  end
end
