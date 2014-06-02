json.array!(@trades) do |trade|
  json.extract! trade, :id, :shop_id, :tid
  json.url trade_url(trade, format: :json)
end
