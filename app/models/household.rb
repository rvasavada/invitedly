class Household < ActiveRecord::Base
  acts_as_taggable
  
  has_many :guests, :dependent => :destroy
  accepts_nested_attributes_for :guests, :allow_destroy => true
  
  has_many :invitations, :dependent => :destroy
  belongs_to :user
  has_many :rsvps, -> { includes(:guest)}, through: :guests
  has_many :events, through: :rsvps
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
  
end