class Occasion < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  has_many :events, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :contacts, :through => :invitations
  has_many :rsvps
  belongs_to :user

  validates :slug, :format => { :with => /\A[a-z0-9_-]{3,}\Z/, :message => "at least 3 characters; only letters, digits, underscores, and hyphens allowed" }
  validates_presence_of :user_id,:name,:description, :slug  
  
  after_validation :move_friendly_id_error_to_name

    def move_friendly_id_error_to_name
      errors.add :slug, *errors.delete(:friendly_id) if errors[:friendly_id].present?
    end
end