json.array!(@invitations) do |invitation|
  json.extract! invitation, :guest_id, :event_id, :num_guests, :message, :response, :is_visible
  json.url invitation_url(invitation, format: :json)
end
