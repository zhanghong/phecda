# encoding : utf-8 -*-
# rake init_system --trace RAILS_ENV=production
task	:init_system => :environment do
	user = User.find_or_initialize_by(email: "erp_admin@phecda.com")
  user.password = "1" * 6
  user.shops = Shop.all
  user.update(name: "admin", mobile: "18012345678", is_superadmin: true)
end