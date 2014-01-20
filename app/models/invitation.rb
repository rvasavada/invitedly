class Invitation < ActiveRecord::Base
  extend FriendlyId
  friendly_id :occasion_id, use: :slugged
  
  has_many :rsvps, :dependent => :destroy
  belongs_to :guest
  belongs_to :occasion
  accepts_nested_attributes_for :rsvps, :reject_if => :all_blank, :allow_destroy => true
  validates_presence_of :occasion_id
  
  
  before_create :create_unique_slug

  private
    def create_unique_slug
      self.slug = SecureRandom.hex
    end
end
