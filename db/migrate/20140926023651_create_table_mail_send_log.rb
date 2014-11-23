class CreateTableMailSendLog < ActiveRecord::Migration
  def change
    create_table :edm_mail_send_log do |t|
      t.integer   :task_id,   default: 0
      t.integer   :email_id,  default: 0
      t.string    :email,     default: "",  limit: 80
      t.datetime  :created_at
      t.datetime  :updated_at
    end
    add_index :edm_mail_send_log,  [:task_id], name: "idx_by_task_id" 
  end
end
