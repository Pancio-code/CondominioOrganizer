class Condominio < ApplicationRecord
  belongs_to :fk_utenti_condo_id
  belongs_to :fk_superutenti_condo_id
end
