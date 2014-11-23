# -*- encoding : utf-8 -*-
class EdmSender < ActionMailer::Base
  #helper :application
  default :from => %q("喜的网络"<service@doorder.com>),
          content_transfer_encoding: '7bit'
  #layout  nil

  def send_to_user(mail_item, email, send_log_id = 0)
    mail_item = mail(
      to: email,
      subject: mail_item.title
    ) rescue mail_item = nil

    mail_item.deliver! if mail_item.present?

    if send_log_id > 0
      Edm::MailSendLog.update_all(["sent_count = sent_count + 1"], id: send_log_id)
    end
  end
end