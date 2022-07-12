class Event < ApplicationRecord
    validates :titolo, length: {minimum: 1, maximum: 30}, allow_blank: false
    belongs_to :condominio
end
