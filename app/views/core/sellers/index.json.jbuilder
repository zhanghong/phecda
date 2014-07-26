json.array!(@core_sellers) do |core_seller|
  json.extract! core_seller, :id, :parent_id, :name, :fullname, :mobile, :phone, :email, :address, :stock_id
  json.url core_seller_url(core_seller, format: :json)
end
