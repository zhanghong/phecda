# encoding : utf-8 -*-
namespace :init do
  # RAILS_ENV=production rake init:system_permissions --trace
  task	:system_permissions => :environment do
    super_admin = User.where(is_superadmin: true).first

    if super_admin.present?
      file_path = File.join(Rails.root, "lib/task_data/system_permissions.xls")
      pmt_tags = {}

      if File.exists?(file_path)

        book = Spreadsheet.open(file_path)
        sheet1 = book.worksheet(0)

        idx, empty_count = -1, 0
        sheet1.each do |row|
          idx += 1
          next if idx == 0
          vals = row.collect{|r| r.to_s.strip}
          module_name, group_name, level_name, tag_name, full_name, name, subject_class, action_name, ability_method = vals
          if tag_name.blank?
            empty_count += 1
            if empty_count > 5
              break
            else
              next
            end
          elsif empty_count > 0
            empty_count = 0
          end

          level = Admin::Permission::LEVELS.find{|l| l.first == level_name}.last

          puts "tag: #{tag_name}, idx: #{idx}"
          
          permission = Admin::Permission.find_or_initialize_by(tag_name: tag_name)
          if permission.update(
            module_name: module_name,
            group_name: group_name,
            level: level,
            name: name,
            full_name: full_name,
            subject_class: subject_class,
            action_name: action_name,
            ability_method: ability_method,
            sort_num: idx
            )
            pmt_tags[tag_name] = full_name
          else
            p permission.errors
          end
        end

        YAML::ENGINE.yamler = 'psych'
        yml_path = File.join(Rails.root, "config/locales/permissions.yml")
        vals = {"zh-CN" => pmt_tags}
        File.open(yml_path, 'w') {|f| f.write vals.to_yaml }
      end
    else
      puts "请先执行 rake init:create_super_admin 创建超级管理员用户"
    end
  end
end