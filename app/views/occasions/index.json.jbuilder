json.array!(@occasions) do |occasion|
  json.extract! occasion, :name, :description, :slug
  json.url occasion_url(occasion, format: :json)
end
