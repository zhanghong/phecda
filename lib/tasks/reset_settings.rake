# encoding : utf-8 -*-
# rake reset_settings --trace RAILS_ENV=production
task	:reset_settings => :environment do
	tb_yaml_path = File.join(Rails.root, "config/taobao.yml")
	cfg = YAML.load_file(tb_yaml_path)
	cfg[Rails.env].each do |k, v|
    attr_name = "tb_#{k}="
    puts "#{attr_name} #{v}"
		Settings.send(attr_name, v)
	end
end