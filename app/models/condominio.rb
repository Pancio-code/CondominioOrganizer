class Condominio < ApplicationRecord

	before_validation :create_code, :create_condomino

	def create_code
		self.flat_code = [*('a'..'z'),*('0'..'9')].shuffle[0,5].join
	end

	def create_condomino
		linkCondo = Condomino.create(condominio_id: self.id, user_id: current_user.id)
	end
	
    def address
        [indirizzo, comune].compact.join(', ')
    end
      
    geocoded_by :address
    after_validation :geocode

    has_many :condominos
    has_many :users, :through => :condominos

    has_one_attached :avatar
    validates :avatar, file_size: { less_than_or_equal_to: 5.megabytes },
               file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif','image/jpg'] }
end
