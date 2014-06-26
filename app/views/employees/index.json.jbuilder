json.array!(@employees) do |employee|
  json.extract! employee, :id, :salary
  json.url employee_url(employee, format: :json)
end
