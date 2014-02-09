class Guest < ActiveRecord::Base
  require 'csv'
  
  belongs_to :user
  belongs_to :household

  has_many :rsvps, :dependent => :destroy
  accepts_nested_attributes_for :rsvps, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :events, :through => :rsvps  
  
  def full_name
    "#{title} #{first_name} #{last_name}"
  end
  
  def self.import(file,occasion,user)
    $row_count = 0
    events = {}
    
    CSV.foreach(file.path) do |row|
      if $row_count == 0
        $i = 8 #where events start

        while $i < row.length do
          events[$i] = row[$i]
          $i += 1
        end
        $row_count += 1
      else  
        if row[0].present?
          household = Household.find_or_create_by_name_and_user_id(row[0],user.id, :email => row[1], :notes => row[2])
        else
          household = Household.create!(name: "#{row[3]} #{row[4]} #{row[5]}",user_id: user.id, :email => row[1], :notes => row[2])
        end
        
        guest = Guest.create!(:user_id => user.id, :household_id => household.id, :title => row[3], :first_name => row[4], :last_name => row[5], :email => row[6], :notes => row[7])
        
        invitation = Invitation.find_or_create_by_household_id_and_occasion_id(:household_id => household.id, :occasion_id => occasion.id)
        
        $i = 8 #where events start
        while $i < row.length do
          if row[$i].present?
            event = Event.find_by_name_and_occasion_id(events[$i],occasion.id)
            if event.present?
              Rsvp.create!(event_id: event.id, guest_id: guest.id, visibility: true, invitation_id: invitation.id)
            end
          end
          $i += 1
        end
      end
    end
  end
end