class CreateSysProperties < ActiveRecord::Migration
  def change
    create_table :sys_properties do |t|
    	t.integer			:account_id,	default: 0
    	t.string			:name,				limit: 30,	default: ""
    	t.string			:status,			limit: 20,	default: ""
      t.timestamps
    end

    add_index		:sys_properties,	[:account_id,	:name],		name: "idx_by_account_id_and_name"
    add_index		:sys_properties,	[:account_id,	:status],	name: "idx_by_account_id_and_status"		
  end
end
