class Invitation < ActiveRecord::Base
  extend FriendlyId
  friendly_id :occasion_id, use: :slugged
  
  belongs_to :invitable, polymorphic: true
  belongs_to :occasion
  
  validates_presence_of :occasion_id
  
  
  before_create :create_unique_slug

  private
    def create_unique_slug
      self.slug = SecureRandom.hex
    end
end