class Invitation < ActiveRecord::Base
  extend FriendlyId
  
  friendly_id :occasion_id, use: :slugged
  before_create :create_unique_slug
  
  belongs_to :invitable, polymorphic: true
  accepts_nested_attributes_for :invitable, :allow_destroy => true
  has_many :rsvps
  accepts_nested_attributes_for :rsvps, :allow_destroy => true
    
  belongs_to :occasion
  has_many :events, :through => :rsvps

  validates_presence_of :occasion_id

  protected

  def create_unique_slug
    self.slug = SecureRandom.hex
  end

end