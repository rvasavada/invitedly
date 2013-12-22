class Event < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  belongs_to :occasions
  has_many :invitations, dependent: :destroy
  has_many :contacts, :through => :invitations
  default_scope { order('start_date ASC, start_time ASC') } 
  validates_presence_of :name,:location,:start_time,:start_date,:description
  accepts_nested_attributes_for :invitations, :reject_if => :all_blank, :allow_destroy => true

  def address
		if country == "United States"
		  address_1 + " " + address_2 + " " + city + ", " + state + " " + zip
		else
		 address_1 + " " + address_2 + " " + city + ", " + region + " " + postal_code
	  end
  end
end
