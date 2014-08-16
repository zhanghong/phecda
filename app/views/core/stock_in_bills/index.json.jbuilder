json.array!(@core_stock_in_bills) do |core_stock_in_bill|
  json.extract! core_stock_in_bill, :id, :stock_id, :cat_name, :status, :customer_name, :area_id, :address, :mobile, :phone, :remark
  json.url core_stock_in_bill_url(core_stock_in_bill, format: :json)
end
