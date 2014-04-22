class Occasion < ActiveRecord::Base
  belongs_to :user
  
  has_many :events, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :rsvps, through: :events

  validates :slug, :format => { :with => /\A[a-z0-9_-]{3,}\Z/, :message => "at least 3 characters; only letters, digits, underscores, and hyphens allowed" }
  validates_presence_of :user_id, :name, :description, :slug  
  validates_uniqueness_of :slug

  accepts_nested_attributes_for :events, :allow_destroy => true
  
  def to_param
    slug
  end
end