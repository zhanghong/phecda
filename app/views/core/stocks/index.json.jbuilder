json.array!(@core_stocks) do |core_stock|
  json.extract! core_stock, :id, :name
  json.url core_stock_url(core_stock, format: :json)
end
