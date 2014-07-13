# encoding : utf-8 -*-
namespace :init do
  # RAILS_ENV=production rake init:add_test_accounts --trace
  task	:add_test_accounts => :environment do
    sys_admin = User.where(email: "erp_admin@phecda.com").first

    [
      {
        name: "旗舰店1",
        phone: "13012395428",
        email: "tmall1@phecda.com",
        token: "6200912f1e4b94f49199ZZ3f44fd95b661812d449e4df8d631257005",
        refresh_token: "6201525eb05ff4feb428b17ccfb59e46ace77fea0f76235631257005"
      },{
        name: "旗舰店2",
        phone: "18612345678",
        email: "tmall2@phecda.com",
        token: "6201c094b13f4e6a1ZZ5e4920bb5bd03c88cb13bbf8ea6d759321604",
        refresh_token: "6201109c822711812ZZ38cc99d746a7a96569e76240e91e759321604"
      }
      ].each do |account_item|
        token = account_item.delete(:token)
        refresh_token = account_item.delete(:refresh_token)
        account = Account.find_or_create_by(name: account_item[:name])
        account.update(account_item)
        sys_admin.accounts << account

        shop = Tb::Shop.find_or_create_by(account_id: account.id, nick: account.name)
        app_token = Tb::AppToken.find_or_create_by(shop_id: shop.id, nick: account.name, access_token:token, refresh_token: refresh_token)
        app_token.refresh
        shop.pull_taobao_info

        TaobaoProductPuller.pull_shop_categories(shop)
        TaobaoProductPuller.pull_all_onsale_items(shop)
      end
  end
end