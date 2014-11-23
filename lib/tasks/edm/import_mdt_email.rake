# encoding : utf-8 -*-
namespace :edm do
  # RAILS_ENV=production rake edm:import_mdt_email --trace
  task	:import_mdt_email => :environment do
    1.upto(10).each do |idx|
      file_path = File.join("/Users/apple/Downloads", "email_#{idx}.csv")
      File.open(file_path) do |file|
        while line = file.gets
          line = line.delete('"') rescue nil
          next if line.nil?
          id, email, name, token = line.split(",")
          next if id.to_i < 10
          email = email.to_s.strip
          next if email.blank?
          name = URI.unescape(name)
          next if name.length > 30
          item = Edm::UserEmail.find_or_initialize_by(email: email)
          item.update(name: name)
          puts "#{id}: #{email}"
        end
      end
      # break
    end
  end
end