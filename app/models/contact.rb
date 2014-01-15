class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :invitations, :dependent => :destroy
  validates_presence_of :household_name, :email
  default_scope { order('household_name ASC') }
  accepts_nested_attributes_for :invitations, :reject_if => :all_blank, :allow_destroy => true
  has_many :rsvps, :dependent => :destroy
  
  has_many :guests, :dependent => :destroy
  accepts_nested_attributes_for :guests, :reject_if => :all_blank, :allow_destroy => true
  
end
