class AddColumnToMailTask < ActiveRecord::Migration
  def change
    add_column  :edm_mail_send_log,   :sent_count,  :integer, default: 0
    add_column  :edm_user_email,      :name,        :string,  default: "", limit: 50
  end
end
