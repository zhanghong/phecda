# encoding : utf-8 -*-
# 修改:增加活动短信和活动邮件发送任务功能
# dayuan.huang + 2011-11-25 修改 2012-05-18
require 'rubygems'
require 'thread'
require 'pp'
require 'yaml'
require "cgi"
gem "mysql2", "0.3.16"
require "mysql2"
gem "i18n", "0.6.11"
gem 'activerecord', '4.0.1'
gem "mail", "2.5.4"
require "net/smtp"
require "base64"
require "mail"
dir = File.dirname(File.expand_path(__FILE__))
DB_FILE = File.join(File.expand_path('../../config/', __FILE__), 'database.yml')
DB_CONFIG = YAML.load_file(DB_FILE)
class Dance

  def initialize(rails_env = "development")
    config = {host: "localhost", username: "root", database: "edm_php"}
    @con = init_mysql_con(config)

    dir = File.dirname(File.expand_path(__FILE__))
    @smtps = YAML::load_file("#{dir}/../config/smtp.yml")   # 读取smtp服务器配置文件
    @emails = YAML::load_file("#{dir}/../config/email.yml") # 读取发送测试邮件和结束邮件的邮箱

    @record = nil
  end

  # last_dance进程会一直循环
  def start
    @con.query("SELECT * FROM edm_task").each do |row|
      @record = row
    end

    if @record
      servers, smtp_names = reload_servers
      server = servers[smtp_names.first]

      puts "+++++++++++ " * 8
      p server
      puts "+++++++++++ " * 8
      send_test_mail(server, @record)
    end
  end

  def send_test_mail(server, mail_item)
    emails = ["zhanghong@doorder.com"]
    test_mail_item = mail_item.clone
    test_mail_item['title'] = mail_item['title'] + '(测试)'
    emails.each {|e| real_send(server, test_mail_item, e)}
    # emails.each do |e|
    #   mail_send_Log_id = save_mysql_send_log("tester", mail_type, object_id, e, nil)
    # end
  end

  # 邮件发送函数
  def real_send(server, mail_item, user_email, send_log_id = 0)
    from = %q("优众网"<info@ihaveu.com>)                       # 初始化发送人
    begin
      mail_content = mail_item["content"].                    # 给邮件加上跟踪标记
        gsub(/http:\/\/www\.ihaveu\.com[^(\"|\')]*/){|l| (l =~ /l\/(\d+)$/)? %(http://data.ihaveu.com/api/cmc/#{send_log_id}?&l=#{$1}) : %(http://data.ihaveu.com/api/callbacks/#{send_log_id}/common_mall_click?mt=#{mail_type}&cb=#{CGI.escape(l)}) }.
        sub(%(</body>), %(<img src='http://data.ihaveu.com/api/cmo/#{send_log_id}?' width='1' height='1'/></body>))

      mail = Mail.new do |m|
        m.from = from
        m.to = user_email
        m.charset = "UTF-8"
        m.content_type = "text/html"
        m.content_transfer_encoding = "7bit"                  # 解决乱码问题
        m.subject = "这是一封测试邮件。。。。。。。" #mail_item["title"]
        m.body = "这是一封测试邮件。。。。。。。" #mail_content
        m.header.charset = "UTF-8"
        m.header["subject"].charset = "UTF-8"                 # 设定主题编码
      end
      puts "---------------------" * 8
      puts mail
      puts mail.deliver!
      puts "+++++++++++++++++++++"
      server.send_mail(mail.to_s, from, user_email)           # 发送邮件
    rescue Exception => e
      puts e.message
      puts e.backtrace
      puts "error: email: #{user_email}"
      return false
    end
    return true                                               # 发送成功返回true，失败返回false
  end

  # 初始化mysql连接
  def init_mysql_con(config)
    Mysql2::Client.new(config.merge({flags: Mysql2::Client::MULTI_STATEMENTS}))
  end

  # 重启smtp服务器
  def reload_servers
    @servers, @smtp_names = load_servers
  end

  # 读取邮件发送服务器并建立连接
  def load_servers
    servers, smtp_names = {}, []
    @smtps.each do |name,info|
      begin
        smtp_server = Net::SMTP.new(info["address"],info["port"])
        if info["starttls"]
          smtp_server.enable_starttls                            # 是否需要开启ssl
        else
          smtp_server.disable_starttls
        end
        if info["authtype"] == :login                            # 是否需要验证
          smtp_server.start(info["domain"],info["user_name"],info["password"],info["authtype"])
        else
          smtp_server.start(info["domain"])
        end
        servers.store(name, smtp_server)                         # 邮件发送服务器存储在@servers中
        smtp_names << name                                       # 服务器名称存储在@smtp_names中
      rescue   Exception => e
        puts e.message
        puts e.backtrace
        puts "Error: #{name} connection failed !"
      end
    end
    raise "No smtp server available !" if smtp_names.size == 0
    return servers, smtp_names
  end
end


Dance.new.start
