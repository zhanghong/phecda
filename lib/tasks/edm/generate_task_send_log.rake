# encoding : utf-8 -*-
namespace :edm do
  # RAILS_ENV=production rake edm:generate_task_send_log --trace
  task	:generate_task_send_log => :environment do
    task_id = ENV["id"]
    mail_item = Edm::Task.find_by_id(task_id)

    Edm::UserEmail.all.each do |user_email|
      puts "email: #{user_email.email}"
      log = Edm::MailSendLog.find_or_initialize_by(task_id: mail_item.id, email_id: user_email.id)
      log.update(email: user_email.email, domain: user_email.domain) if log.new_record?
    end if mail_item.present?
  end
end