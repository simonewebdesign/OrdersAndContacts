json.array!(@people) do |person|
  json.extract! person, :id, :age
  json.url person_url(person, format: :json)
end
