json.array!(@events) do |event|
  json.extract! event, :name, :description, :occasion_id, :start_date, :start_time, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :location, :slug
  json.url event_url(event, format: :json)
end
