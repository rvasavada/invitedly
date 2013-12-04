json.array!(@contacts) do |contact|
  json.extract! contact, :user_id, :contact_id, :address_1, :address_2, :city, :state, :zip, :country, :region, :postal_code, :first_name, :last_name, :title, :spouse_title, :spouse_first_name, :spouse_last_name, :cell_phone, :home_phone, :max_guests
  json.url contact_url(contact, format: :json)
end
