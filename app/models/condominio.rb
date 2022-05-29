class Condominio < ApplicationRecord
    def address
        [indirizzo, comune].compact.join(', ')
      end
    geocoded_by :address
    after_validation :geocode
end
