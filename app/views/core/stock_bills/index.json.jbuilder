json.array!(@core_stock_bills) do |core_stock_bill|
  json.extract! core_stock_bill, :id, :stock_id, :cat_name, :status, :customer_name, :area_id, :address, :mobile, :phone, :remark
  json.url core_stock_bill_url(core_stock_bill, format: :json)
end
