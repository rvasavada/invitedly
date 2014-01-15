class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :invitations, :dependent => :destroy
  validates_presence_of :first_name, :last_name, :email
  validates_presence_of :household_name, :if => :needs_family_name?
  
  #default_scope { order('household_name ASC') }
  accepts_nested_attributes_for :invitations, :reject_if => :all_blank, :allow_destroy => true
  has_many :rsvps, :dependent => :destroy
  
  has_many :guests, :dependent => :destroy
  accepts_nested_attributes_for :guests, :reject_if => :all_blank, :allow_destroy => true
  
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
  
end