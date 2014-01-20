class Household < ActiveRecord::Base
  has_many :guests
  accepts_nested_attributes_for :guests, :reject_if => :all_blank, :allow_destroy => true
  
  has_one :invitation, as: :invitable, :dependent => :destroy
  
  belongs_to :user
end
