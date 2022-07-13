class GdriveUserItem < ApplicationRecord
  belongs_to :condomino
  belongs_to :gdrive_condo_item, optional:true
end
