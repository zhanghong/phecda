# encoding : utf-8 -*-
namespace :edm do
  # RAILS_ENV=production rake edm:send_test_mail id=2 --trace
  task	:send_test_mail => :environment do
    mail_item = Edm::Task.find_by_id(ENV["id"])

    if ENV["real"] == true || ENV["real"] == "true"
      # while true do
      #   start_time = Time.now
      #   logs = Edm::MailSendLog.rand_find(mail_item)
      #   break if logs.blank?
      #   logs.each do |log|
      #     EdmSender.send_to_user(mail_item, log.email, log.id)
      #     # sleep(0.1)
      #     puts "id: #{log.id}, email: #{log.email}"
      #   end

      #   #确保每小时每个域名发送的邮件数量不能超过1800封
      #   use_second = Time.now - start_time
      #   #sleep_second = 2 - use_second
      #   # sleep(sleep_second) if sleep_second > 0
      #   sleep(3)
      # end
    else
      # %w(zhanghong@doorder.com).each do |email|
      %w(yanghui@doorder.com 2365038925@qq.com).each do |email|
      # %w(wynn@doorder.com mark@doorder.com michelle@doorder.com).each do |email|
        puts "tester: #{email}"     
        EdmSender.send_to_user(mail_item, email, 0)
      end
    end
  end
end