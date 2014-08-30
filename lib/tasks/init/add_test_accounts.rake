# encoding : utf-8 -*-
namespace :init do
  # RAILS_ENV=production rake init:add_test_accounts --trace
  task	:add_test_accounts => :environment do
    [
      {
        name: "phecda_erp",
        key_id: "21366151",
        secret: "d7580da21e45ed89535e0702abda5a2d"
      },{
        name: "phecda",
        key_id: "21670514",
        secret: "e51907ccfb450954a95d9f6b48ad4112"
      }
    ].each do |app|
      tb_app = Tb::App.find_or_initialize_by(key_id: app[:key_id])
      tb_app.update(app)
    end

    default_app = Tb::App.where(key_id: "21366151").first

    [
      {
        name: "b旗舰店",
        phone: "13012395428",
        email: "tmall1@phecda.com",
        token: "6201707fe1fe100ZZc5ab70173868cb3b105eeb392bf65b631257005",
        refresh_token: "62012078ce69726ZZ711701a0f75dcb2ab535bd8c9a4e70631257005"
      },{
        name: "d旗舰店",
        phone: "18612345678",
        email: "tmall2@phecda.com",
        token: "62022267b0b64ea2a4d6880d5f6aa098ccegc189fc20bfc759321604",
        refresh_token: "62007264e6563ec04f649abcab3f5c5572ZZ377b5c6a5bf759321604"
      }
      ].each do |account_item|
        token = account_item.delete(:token)
        refresh_token = account_item.delete(:refresh_token)
        account = Account.find_or_initialize_by(name: account_item[:name])
        account.update(account_item)
        account.refresh


        shop = Tb::Shop.find_or_create_by(account_id: account.id, nick: account.name)
        app_token = Tb::AppToken.find_or_initialize_by(shop_id: shop.id)
        app_token.update({
            app_id: default_app.id,
            nick: account.name,
            access_token:token,
            refresh_token: refresh_token
          })

        app_token.refresh
        shop.pull_taobao_info

        TaobaoProductPuller.pull_shop_categories(shop)
        TaobaoProductPuller.pull_all_onsale_items(shop)
      end
  end
end