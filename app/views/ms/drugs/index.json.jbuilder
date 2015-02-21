json.array!(@ms_drugs) do |ms_drug|
  json.extract! ms_drug, :id, :name, :type, :unit, :unit_price, :inventory, :byname, :resume, :notice
  json.url ms_drug_url(ms_drug, format: :json)
end
