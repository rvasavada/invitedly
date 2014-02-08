class Invitation < ActiveRecord::Base
  extend FriendlyId
  friendly_id :occasion_id, use: :slugged
  
  belongs_to :invitable, polymorphic: true
  belongs_to :occasion
  
  validates_presence_of :occasion_id
  
  
  before_create :create_unique_slug
  
  has_many :events, :through => :rsvps
  has_many :rsvps
  accepts_nested_attributes_for :rsvps, :allow_destroy => true
  

  private
    def create_unique_slug
      self.slug = SecureRandom.hex
    end
end