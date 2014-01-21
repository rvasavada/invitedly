class Household < ActiveRecord::Base
  has_many :guests
  accepts_nested_attributes_for :guests, :allow_destroy => true
  
  has_one :invitation, as: :invitable, :dependent => :destroy
  belongs_to :user
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
end
