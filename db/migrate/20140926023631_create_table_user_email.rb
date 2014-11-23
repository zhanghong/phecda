class CreateTableUserEmail < ActiveRecord::Migration
  def change
    create_table :edm_user_email do |t|
      t.string    :email,     default: "",    limit: 80
      t.string    :domain,    default: "",    limit: 50
      t.string    :status,    default: "actived", limit: 20
      t.integer   :creater_id,      default: 0
      t.integer   :updater_id,      default: 0
      t.datetime  :created_at
      t.datetime  :updated_at
    end
    add_index :edm_user_email,  [:domain, :status],  name: "idx_by_domail_and_status"
  end
end
