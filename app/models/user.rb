class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]
  
  has_one :occasion, :dependent => :destroy
  has_many :events, :through => :occasion
  has_many :guests
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    signed_in_resource.facebook_uid = auth.uid
    signed_in_resource.facebook_token = auth.credentials.token
    
    signed_in_resource.save
  end
end
