class GdriveCondoItem < ApplicationRecord
  belongs_to :condominio
  has_many :gdrive_user_items
end
