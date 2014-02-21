class Household < ActiveRecord::Base
  acts_as_taggable
  
  belongs_to :user
  
  has_many :guests, :dependent => :destroy
  accepts_nested_attributes_for :guests, :allow_destroy => true
  
  has_many :invitations, :dependent => :destroy
  
  has_many :rsvps, -> { includes(:guest)}, through: :guests

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
end