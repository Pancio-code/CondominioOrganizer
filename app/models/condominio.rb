class Condominio < ApplicationRecord
    def address
        [indirizzo, comune].compact.join(', ')
      end
    geocoded_by :address
    after_validation :geocode

    has_one_attached :avatar
    validates :avatar, file_size: { less_than_or_equal_to: 5.megabytes },
               file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif','image/jpg'] }
end
