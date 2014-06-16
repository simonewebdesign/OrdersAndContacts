json.array!(@companies) do |company|
  json.extract! company, :id, :website
  json.url company_url(company, format: :json)
end
