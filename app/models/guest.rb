class Guest < ActiveRecord::Base
  require 'CSV'
  
  belongs_to :user
  belongs_to :household
  has_one :invitation, as: :invitable, :dependent => :destroy
  accepts_nested_attributes_for :invitation, :reject_if => :all_blank, :allow_destroy => true
  has_many :rsvps
  accepts_nested_attributes_for :rsvps, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :events, :through => :rsvps  
  #validates_presence_of :first_name, :last_name, :email
  #validates_presence_of :household_name, :if => :needs_family_name?
  #validates_uniqueness_of :email, :scope => :user  

  
  def full_name
    "#{title} #{first_name} #{last_name}"
  end
  
  def needs_family_name?
    is_family
  end
  
  def guest_names
    guest_array = []
    guest_array.push("#{title} #{first_name} #{last_name}")
    self.guests.each do |guest|
      guest_array.push(guest.full_name)
    end
    guest_array.join(', ')
  end
  
  def self.import(file,occasion,user)
    CSV.foreach(file.path, headers: true) do |row|
      if row[0].present?        
        household = Household.find_or_create_by_name(:name => row[0],
                                                     :user_id => user.id, 
                                                     :email => row[1], 
                                                     :notes => row[2])
        guest = Guest.create!(:user_id => user.id,
                      :household_id => household.id,
                      :title => row[3],
                      :first_name => row[4],
                      :last_name => row[5],
                      :email => row[6],
                      :notes => row[7])

        Invitation.find_or_create_by_invitable_type_and_invitable_id("Household",household.id,:occasion_id => occasion.id)
      else
        guest = Guest.create!(:user_id => user.id,
                          :title => row[3],
                          :first_name => row[4],
                          :last_name => row[5],
                          :email => row[6],
                          :notes => row[7])
        guest.create_invitation!(:occasion_id => occasion.id)
      end
    end
  end
end