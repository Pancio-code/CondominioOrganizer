class Condominio < ApplicationRecord
	before_validation :create_code
    validates :comune, length: {minimum: 1, maximum: 25}, allow_blank: false
    validates :nome, length: {minimum: 1, maximum: 25}, allow_blank: false
    validates :indirizzo, allow_blank: false, format: { with: %r{(via|corso|viale|piazza|Via|Corso|Viale|Piazza)[ ][a-zA-Z]([ ](?![ ])|[a-zA-Z]){1,}[ ][0-9]{1,}\z}i ,message: 'invalido, formato: Via Tiburtina 214'} 

	def create_code
		self.flat_code = [*('a'..'z'),*('0'..'9')].shuffle[0,5].join
	end
	
    has_many :condominos,dependent: :destroy
    has_many :events,dependent: :delete_all
    has_many :users, through: :condominos

    accepts_nested_attributes_for :condominos
    
    has_one :gdrive_condo_item, dependent: :delete 

    has_many :posts,dependent: :destroy
    has_many :comments
#	def create_condomino
#		linkCondo = Condomino.create(condominio_id: self.id, user_id: current_user.id)
#	end
	
    def address
        [indirizzo, comune].compact.join(', ')
    end

    geocoded_by :address
    after_validation :geocode

    has_one_attached :avatar
    validates :avatar, file_size: { less_than_or_equal_to: 5.megabytes },
               file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif','image/jpg'] }
end
