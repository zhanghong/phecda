class AddColumnDomainToEdmMailSendLog < ActiveRecord::Migration
  def change
    add_column  :edm_mail_send_log,   :domain,  :string, default: "",  limit: 30
  end
end
