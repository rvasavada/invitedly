class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :invitations
  validates_presence_of :first_name,:last_name, :max_guests
  default_scope { order('last_name ASC') } 
  
  def invite_name
    if (spouse_first_name.present? and spouse_last_name.present?)
      if(spouse_last_name != last_name)
        (title || '') + " " + (first_name || '') + " " + (last_name || '') + " & " + (spouse_title || '') + " " + (spouse_first_name  || '') + " " + (spouse_last_name  || '')
      else
        (title || '') + " " + (first_name || '') + " & " + (spouse_title || '') + " " + (spouse_first_name  || '') + " " + (last_name || '')
      end
    else
      (title || '') + " " + (first_name || '') + " " + (last_name || '')
    end
  end

end
