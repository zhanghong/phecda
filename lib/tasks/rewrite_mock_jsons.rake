# encoding : utf-8 -*-

def load_file(path, rewite_type = "")
  Dir.foreach(path) do |file|
    if file != "." && file != ".."
      file_path = File.join(path, file)
      if File.directory?(file_path)
        load_file(file_path, rewite_type) 
      else
        rewrite_type_file(file_path, rewite_type)
      end
    end
  end
end

def rewrite_type_file(file_path, rewrite_type)
  case rewrite_type
  when "json"
    yml_to_json(file_path)
  when "yml"
    json_to_yml(file_path)
  end
end

def yml_to_json(yml_path)
  if File.extname(yml_path) == ".yml"
    json_path = yml_path.gsub(".yml", ".json")
    yml_data = YAML::load_file(yml_path)
    File.open(json_path, "w"){|f| f.puts yml_data.to_json}
  end
end

def json_to_yml(json_path)
  if File.extname(json_path) == ".json"
    body = File.read(json_path)
    json = JSON.parse(body)
    yml_path = json_path.gsub(".json", ".yml")
    File.open(yml_path, 'w') {|f| f.write json.to_yaml }
  end
end

# 重写所有测试文件
# rake rewrite_all_mock_data type="" --trace RAILS_ENV=production
task	:rewrite_all_mock_data => :environment do
  root_path = File.join(Rails.root, "spec/mock_data")
  load_file(root_path, ENV["type"])
end

# 重写单个测试文件 
# rake rewrite_mock_file file="" type="" --trace RAILS_ENV=production
task  :rewrite_mock_file => :environment do
  file_path = File.join(Rails.root, "spec/mock_data", file)
  rewrite_type_file(file_path, ENV["type"])
end