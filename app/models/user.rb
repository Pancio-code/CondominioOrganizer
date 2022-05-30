class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :uname, presence: true, uniqueness: { scope: :email, case_sensitive: false }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.da_omniauth(acc_token)
  	data = acc_token.info
  	user = User.find_by(uname: data['name'],email: data['email'])
       return user if user
       user = User.create(uname: data['name'],
              email: data['email'],
              password: Devise.friendly_token[0,20],
              from_oauth: true
       )
       
   end

   def valid_password?(password)  
       from_oauth? || super(password)  
   end

   has_many :condominos
   has_many :condominios, through: :condominos

   has_one_attached :avatar
   validates :avatar, file_size: { less_than_or_equal_to: 5.megabytes },
              file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif','image/jpg'] }
end
