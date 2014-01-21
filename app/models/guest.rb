class Guest < ActiveRecord::Base
  belongs_to :user
  
  has_one :invitation, as: :invitable, :dependent => :destroy
  accepts_nested_attributes_for :invitation, :reject_if => :all_blank, :allow_destroy => true
  has_many :rsvps
  accepts_nested_attributes_for :rsvps, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :events, :through => :rsvps  
  #validates_presence_of :first_name, :last_name, :email
  #validates_presence_of :household_name, :if => :needs_family_name?
  #validates_uniqueness_of :email, :scope => :user  

  
  def full_name
    title + " " + first_name + " " + last_name
  end
  
  def needs_family_name?
    is_family
  end
  
  def guest_names
    guest_array = []
    guest_array.push(title + " " + first_name + " " + last_name)
    self.guests.each do |guest|
      guest_array.push(guest.full_name)
    end
    guest_array.join(', ')
  end
  
end