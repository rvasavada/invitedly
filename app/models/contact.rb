class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :invitations
  validates_presence_of :household_name, :max_guests,:email
  default_scope { order('household_name ASC') }
  accepts_nested_attributes_for :invitations, :reject_if => :all_blank, :allow_destroy => true
  has_many :rsvps
end
