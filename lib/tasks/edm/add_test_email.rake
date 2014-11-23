# encoding : utf-8 -*-
require 'net/http'
require 'crack/json'
namespace :edm do
  # RAILS_ENV=production rake edm:add_test_email --trace
  task	:add_test_email => :environment do
    
    # while true
    #   sorted_params = {
    #     start_num: 1,
    #     end_num: 10
    #   }
    #   Net::HTTP.start('http://doorder.we.jaeapp.com', 80) {|http|
    #     response = http.get("/data.php?start_num=1&end_num=10", {'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Trident/4.0)'})
    #     puts response
    #     puts response.body
    #   }
    #   # response = Excon.get("http://doorder.we.jaeapp.com/data.php?start_num=1&end_num=10", :headers => {'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Trident/4.0)'})
    #   # # response = Excon.get("http://www.baidu.com/s?wd=ruby%20http%20get&rsv_spt=1&issp=1&f=8&rsv_bp=0&ie=utf-8&tn=baiduhome_pg&bs=ruby%20http")
    #   # puts response.body
    #   # res = JSON.parse(response.body, :quirks_mode => true)
    #   # puts "+++++++++++++++++++ " * 8
    #   # p res
    #   # puts "------------------- " * 8
    #   break
    # end

    domains = ["126.com", "163.com", "qq.com", "hotmail.com", "sina.com", "yahoo.com.cn", "gmail.com", "sohu.com", "139.com", "yahoo.cn", "tom.com",
                "21cn.com", "vip.sina.com", "msn.com", "live.cn", "yahoo.com", "yeah.net", "vip.qq.com", "vip.163.com", "263.net", "cmbc.com.cn", "foxmail.com",
                "189.cn", "sina.cn", "caogov.com", "eyou.com", "ihaveu.net", "163.net", "live.com", "cmbchina.com", "msn.cn", "citiz.net", "vip.sohu.com", "188.com",
                "wo.com.cn", "china.com", "21cn.net", "sh163.net", "sogou.com", "fudan.edu.cn", "online.sh.cn", "hotmai.com", "petrochina.com.cn", "bankcomm.com"]

    len = domains.size

    1.upto(50000) do |i|
      idx = rand(len)
      idx = 0 if idx >= len
      domain = domains[idx]

      email = "test_#{i}@#{domain}"
      Edm::UserEmail.create(email: email, domain: domain)
      puts email
    end

  end
end