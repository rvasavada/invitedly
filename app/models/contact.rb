class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :invitations
  validates_presence_of :household_name, :max_guests
  default_scope { order('household_name ASC') }
end
