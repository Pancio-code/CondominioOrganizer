class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :uname, presence: true ,uniqueness: { case_sensitive: false } 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.da_omniauth(acc_token)
  	data = acc_token.info
  	user = User.where(email: data['email']).first

  	unless user
  		user = User.create(uname: data['name'],
  			email: data['email'],
  			password: Devise.friendly_token[0,20]
  		)
  	end
   end


   has_one_attached :avatar
end
