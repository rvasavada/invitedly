class Occasion < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  has_many :events
  belongs_to :user
  
  validates_presence_of :user_id,:name,:description, :slug  
end