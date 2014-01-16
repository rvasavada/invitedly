class Invitation < ActiveRecord::Base
  has_many :rsvps, :dependent => :destroy
  belongs_to :contact
  belongs_to :occasion
  accepts_nested_attributes_for :rsvps, :reject_if => :all_blank, :allow_destroy => true
  validates_presence_of :occasion_id
  

end
