class Rsvp < ActiveRecord::Base
  belongs_to :occasion
  belongs_to :contact
end
