class Occasion < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  belongs_to :user
  
  has_many :events, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :rsvps, through: :events

  validates_presence_of :name, :description

  accepts_nested_attributes_for :events, :allow_destroy => true
  
end