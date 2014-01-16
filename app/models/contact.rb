class Contact < ActiveRecord::Base
  belongs_to :user
  
  has_one :invitation, :dependent => :destroy
  accepts_nested_attributes_for :invitation, :reject_if => :all_blank, :allow_destroy => true
  has_many :rsvps, through: :invitation
  has_many :guests, :dependent => :destroy
  accepts_nested_attributes_for :guests, :reject_if => :all_blank, :allow_destroy => true
  
  validates_presence_of :first_name, :last_name, :email
  validates_presence_of :household_name, :if => :needs_family_name?
  
  #default_scope { order('household_name ASC') }
  

  
  def contact_name
    if is_family
      household_name
    else
      title + " " + first_name + " " + last_name
    end
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