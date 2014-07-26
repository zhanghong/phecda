# encoding : utf-8 -*-
namespace :init do
  # RAILS_ENV=production rake init:create_super_admin --trace
  task  :create_super_admin => :environment do
    user = User.find_or_initialize_by(email: "erp_admin@phecda.com")
    user.password = "1" * 6
    user.accounts = Account.all
    user.update(name: "admin", mobile: "18012345678", is_superadmin: true)
  end
end