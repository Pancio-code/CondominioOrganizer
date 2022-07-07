class Condomino < ApplicationRecord
	belongs_to :user
	belongs_to :condominios, optional: true
end
