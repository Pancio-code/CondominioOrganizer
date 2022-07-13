class Condomino < ApplicationRecord 
	belongs_to :user
	belongs_to :condominios, optional: true

        has_many :gdrive_user_items, dependent: :delete_all
end
