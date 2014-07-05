# encoding : utf-8 -*-
namespace :init do
  # RAILS_ENV=production rake init:clone_taobao_products shop_id=1 --trace
  task	:clone_taobao_products => :environment do
    Tb::Product.unscoped.where(shop_id: ENV["shop_id"]).all.each do |p|
      p.clone_to_sys
      puts "---- #{p.id} ------"
    end
  end
end